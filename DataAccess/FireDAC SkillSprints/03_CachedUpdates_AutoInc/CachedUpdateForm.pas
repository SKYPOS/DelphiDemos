{
  ���� �� : http://blog.hjf.pe.kr/336
}
unit CachedUpdateForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.ExtCtrls, Vcl.DBCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.UI, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQuery1SEQ: TIntegerField;
    FDQuery1FIELD1: TWideStringField;
    FDQuery1FIELD2: TIntegerField;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    GroupBox1: TGroupBox;
    btnCancelRefresh: TButton;
    btnApplyUpdates: TButton;
    chkUseCachedUpdates: TCheckBox;
    Label1: TLabel;
    chkUseAutoGenerateValue: TCheckBox;
    FDTable1: TFDTable;
    procedure btnCancelRefreshClick(Sender: TObject);
    procedure btnApplyUpdatesClick(Sender: TObject);
    procedure chkUseCachedUpdatesClick(Sender: TObject);
    procedure chkUseAutoGenerateValueClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

// <������ ����>
 // SAMPLE.GDB������ FDConnection1 > Database�� ����
procedure TForm2.chkUseAutoGenerateValueClick(Sender: TObject);
begin
  // SEQ �ʵ�� PK(�ڵ�����) ������ ������
  FDQuery1.Close;
  if chkUseAutoGenerateValue.Checked then
  begin
    FDQuery1SEQ.AutoGenerateValue := arAutoInc;
    FDQuery1SEQ.Required := False;
    FDQuery1SEQ.ReadOnly := True;
    // ���ο� ���ڵ� �߰� �� SEQ�� (-1 -> -2 -> -3 ���� �ڵ� ������)
  end
  else
  begin
    FDQuery1SEQ.AutoGenerateValue := arNone;
    FDQuery1SEQ.Required := True;
    FDQuery1SEQ.ReadOnly := False;
    // ���ο� ���ڵ� �߰� �� NULL�� ������(���� ���� �ʿ�)
    // ����(Post) �� 'Must have a value' ���� �߻�
  end;
  FDQuery1.Open;
end;

procedure TForm2.chkUseCachedUpdatesClick(Sender: TObject);
var
  UseCachedUpdates: Boolean;
begin
  UseCachedUpdates := chkUseCachedUpdates.Checked;

  FDQuery1.CachedUpdates := UseCachedUpdates;

  btnCancelRefresh.Enabled := UseCachedUpdates;
  btnApplyUpdates.Enabled := UseCachedUpdates;
end;

procedure TForm2.btnCancelRefreshClick(Sender: TObject);
begin
  FDQuery1.CancelUpdates;
  FDQuery1.Refresh;
end;

procedure TForm2.btnApplyUpdatesClick(Sender: TObject);
var
  iErr: Integer;
begin
  FDConnection1.StartTransaction;

  // ApplyUpdates�� ������ �߻����� ����
  iErr := FDQuery1.ApplyUpdates(-1);
  if iErr = 0 then
  begin
    FDQuery1.CommitUpdates; // ����α� �����
    FDConnection1.Commit;
  end
  else
    FDConnection1.Rollback;

  FDQuery1.Refresh;
end;

end.
