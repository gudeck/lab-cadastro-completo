unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, Vcl.ToolWin, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    Connection: TADOConnection;
    QDisciplina: TADOQuery;
    PDisciplina: TDataSetProvider;
    MDisciplina: TClientDataSet;
    DsDisciplina: TDataSource;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    btNovo: TToolButton;
    btExcluir: TToolButton;
    btSalvar: TToolButton;
    btCancelar: TToolButton;
    btAlterar: TToolButton;
    btAnterior: TToolButton;
    btProximo: TToolButton;
    PCadastro: TPanel;
    DBGrid1: TDBGrid;
    MDisciplinaID: TLargeintField;
    MDisciplinaNOME: TStringField;
    MDisciplinaDESCRICAO: TStringField;
    MDisciplinaMEDIA: TIntegerField;
    MDisciplinaOPCIONAL: TBooleanField;
    MDisciplinaDATA_CRIACAO: TDateTimeField;
    Label2: TLabel;
    DBEditCodigo: TDBEdit;
    Label3: TLabel;
    DBEditNome: TDBEdit;
    Label4: TLabel;
    DBEditDescricao: TDBEdit;
    Label6: TLabel;
    DBEditMedia: TDBEdit;
    DBCBOpcional: TDBCheckBox;
    Label7: TLabel;
    DBEditDataCriacao: TDBEdit;
    Label5: TLabel;
    procedure MDisciplinaAfterPost(DataSet: TDataSet);
    procedure MDisciplinaAfterDelete(DataSet: TDataSet);
    procedure MDisciplinaAfterCancel(DataSet: TDataSet);
    procedure MDisciplinaAfterInsert(DataSet: TDataSet);

    procedure StatusBarra(ds: TDataSet);
    procedure btNovoClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btAnteriorClick(Sender: TObject);
    procedure btProximoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btAlterarClick(Sender: TObject);
begin
  MDisciplina.Edit;
  StatusBarra(MDisciplina);
end;

procedure TForm1.btAnteriorClick(Sender: TObject);
begin
  MDisciplina.Prior;
end;

procedure TForm1.btCancelarClick(Sender: TObject);
begin
  MDisciplina.Cancel;
  StatusBarra(MDisciplina);
end;

procedure TForm1.btExcluirClick(Sender: TObject);
begin
  if Application.MessageBox(Pchar('Deseja excluir o arquivo?'), 'Confirmação',
    MB_USEGLYPHCHARS + MB_DEFBUTTON2) = mrYes then
  begin
    MDisciplina.Delete;
    StatusBarra(MDisciplina);
  end;
end;

procedure TForm1.btNovoClick(Sender: TObject);
begin
  MDisciplina.Append;
  StatusBarra(MDisciplina);
  DBCBOpcional.Checked := False;
  DBEditNome.SetFocus;
end;

procedure TForm1.btProximoClick(Sender: TObject);
begin
  MDisciplina.Next;
end;

procedure TForm1.btSalvarClick(Sender: TObject);
begin
  MDisciplina.Post;
  QDisciplina.Close;
  MDisciplina.Close;

  MDisciplina.Open;
  StatusBarra(MDisciplina);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  QDisciplina.Open;
  MDisciplina.Open;
  StatusBarra(MDisciplina);
end;

procedure TForm1.MDisciplinaAfterCancel(DataSet: TDataSet);
begin
  MDisciplina.CancelUpdates;
end;

procedure TForm1.MDisciplinaAfterDelete(DataSet: TDataSet);
begin
  MDisciplina.ApplyUpdates(-1);
end;

procedure TForm1.MDisciplinaAfterInsert(DataSet: TDataSet);
begin
  MDisciplinaDATA_CRIACAO.AsDateTime := Now;
  MDisciplinaMEDIA.AsInteger := 60;
  DBCBOpcional.Checked := False;
end;

procedure TForm1.MDisciplinaAfterPost(DataSet: TDataSet);
begin
  MDisciplina.ApplyUpdates(-1);
end;

procedure TForm1.StatusBarra(ds: TDataSet);
begin
  btNovo.Enabled := not(ds.State in [dsEdit, dsInsert]);
  btSalvar.Enabled := ds.State in [dsEdit, dsInsert];
  btExcluir.Enabled := not(ds.State in [dsEdit, dsInsert]) and not(ds.IsEmpty);
  btAlterar.Enabled := not(ds.State in [dsEdit, dsInsert]) and not(ds.IsEmpty);
  btCancelar.Enabled := ds.State in [dsEdit, dsInsert];
  btAnterior.Enabled := not(ds.State in [dsEdit, dsInsert]) and not(ds.IsEmpty);
  btProximo.Enabled := not(ds.State in [dsEdit, dsInsert]) and not(ds.IsEmpty);
  PCadastro.Enabled := ds.State in [dsEdit, dsInsert];
end;

end.
