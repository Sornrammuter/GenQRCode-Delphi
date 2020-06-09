unit Unit1;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    // Qrcode
    DelphiZXingQRCode, FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error,
    FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Phys.MSAccDef,
    FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, FireDAC.Comp.UI, Data.DB,
    FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Menus, Vcl.ExtDlgs;

type
    TFormMain = class(TForm)
        edtText: TLabeledEdit;
        edtQuietZone: TLabeledEdit;
        cmbEncoding: TComboBox;
        PaintBox1: TPaintBox;
        FDConn: TFDConnection;
        FDQuery: TFDQuery;
        WaitCursor: TFDGUIxWaitCursor;
        MSAccess: TFDPhysMSAccessDriverLink;
        Button1: TButton;
        Image1: TImage;
        Button2: TButton;
        FDQuery2: TFDQuery;
        Button3: TButton;
        PopupMenu1: TPopupMenu;
        SaveAsImage1: TMenuItem;
        SavePicture: TSavePictureDialog;
        SaveAsImage2: TMenuItem;
        procedure PaintBox1Paint(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure edtTextChange(Sender: TObject);
        procedure cmbEncodingChange(Sender: TObject);
        procedure edtQuietZoneChange(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
        procedure Button3Click(Sender: TObject);
        procedure SaveAsImage2Click(Sender: TObject);
    private
        QRCodeBitmap: TBitmap;
        { Private declarations }
    public
        { Public declarations }
        procedure Update;
    end;

var
    FormMain: TFormMain;

implementation

uses
    Clipbrd;
{$R *.dfm}
{ TForm1 }

procedure TFormMain.Button1Click(Sender: TObject);
var
    img_save: TMemoryStream;
begin
    img_save := TMemoryStream.Create;
    QRCodeBitmap.SaveToStream(img_save);
    img_save.Seek(0, 0);

    with FDQuery do
    begin
        Close;
        Open;
        Append;
        TBlobField(FieldByName('FieldBlob')).LoadFromStream(img_save);
        Post;
    end;

    img_save.Free;

end;

procedure TFormMain.Button2Click(Sender: TObject);
var
    blob: TStream;
begin

    with FDQuery2 do
    begin
        Close;
        Open;
        blob := FDQuery2.CreateBlobStream(FDQuery2.FieldByName('FieldBlob'),
          TBlobStreamMode.bmRead);
        Image1.Picture.Bitmap.LoadFromStream(blob);
    end;

end;

procedure TFormMain.Button3Click(Sender: TObject);
var
    Bitmap: TBitmap;
begin
    Bitmap := TBitmap.Create;
    try
        Bitmap.Width := PaintBox1.Width;
        Bitmap.Height := PaintBox1.Height;
        BitBlt(Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height,
          PaintBox1.Canvas.Handle, 0, 0, SRCCOPY);
        Clipboard.Assign(Bitmap);
    finally
        Bitmap.Free;
        ShowMessage('Clipboard Image')
    end;
end;

procedure TFormMain.cmbEncodingChange(Sender: TObject);
begin
    Update;
end;

procedure TFormMain.edtQuietZoneChange(Sender: TObject);
begin
    Update;
end;

procedure TFormMain.edtTextChange(Sender: TObject);
begin
    Update;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
    QRCodeBitmap := TBitmap.Create;
    Update;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
    QRCodeBitmap.FreeImage;
end;

procedure TFormMain.PaintBox1Paint(Sender: TObject);
var
    Scale: Double;
begin
    PaintBox1.Canvas.Brush.Color := clWhite;
    PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height));
    if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then
    begin
        if (PaintBox1.Width < PaintBox1.Height) then
        begin
            Scale := PaintBox1.Width / QRCodeBitmap.Width;
        end
        else
        begin
            Scale := PaintBox1.Height / QRCodeBitmap.Height;
        end;
        PaintBox1.Canvas.StretchDraw
          (Rect(0, 0, Trunc(Scale * QRCodeBitmap.Width),
          Trunc(Scale * QRCodeBitmap.Height)), QRCodeBitmap);
    end;
end;

procedure TFormMain.SaveAsImage2Click(Sender: TObject);
var
    Bitmap: TBitmap;

begin
    if SavePicture.Execute then
    begin
        Bitmap := TBitmap.Create;
        try
            Bitmap.Width := PaintBox1.Width;
            Bitmap.Height := PaintBox1.Height;
            BitBlt(Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height,
              PaintBox1.Canvas.Handle, 0, 0, SRCCOPY);
            // Clipboard.Assign(Bitmap);
            Bitmap.SaveToFile(SavePicture.FileName);
        finally
            Bitmap.Free;
            ShowMessage('Save Image')
        end;

    end;
end;

procedure TFormMain.Update;
var
    QRCode: TDelphiZXingQRCode;
    Row, Column: Integer;
begin
    QRCode := TDelphiZXingQRCode.Create;
    try
        QRCode.Data := edtText.Text;
        QRCode.Encoding := TQRCodeEncoding(cmbEncoding.ItemIndex);
        QRCode.QuietZone := StrToIntDef(edtQuietZone.Text, 4);
        QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
        for Row := 0 to QRCode.Rows - 1 do
        begin
            for Column := 0 to QRCode.Columns - 1 do
            begin
                if (QRCode.IsBlack[Row, Column]) then
                begin
                    QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
                end
                else
                begin
                    QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
                end;
            end;
        end;
    finally
        QRCode.Free;
    end;
    PaintBox1.Repaint;
end;

end.
