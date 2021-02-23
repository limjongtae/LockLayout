unit Dock.FormView;

interface

uses
  DockList, ResourceUtils, DockMultipleSelections, DockUnit,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, System.Math;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    TrackBar1: TTrackBar;
    ScrollBox1: TScrollBox;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ScrollBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ScrollBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
    FDockUnit: TDockList;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  FDockUnit.Add;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  FDockUnit.Clear;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  ClickSound;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  FDockUnit.Refresh;
end;

//
procedure TForm2.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  if not Assigned(FDockUnit) then
    FDockUnit := TDockList.Create(ScrollBox1);

  DoubleBuffered := True;

  LockWindowUpdate(Application.Handle);
  try
    for i := 0 to 50 do
     FDockUnit.Add;
  finally
     LockWindowUpdate(0);
  end;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  if Assigned(FDockUnit) then
    FDockUnit.Free;
end;

procedure TForm2.ScrollBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Shift = [ssLeft] then
    FDockUnit.MultiSelection.ClickPoint := Self.ClientToScreen(Point(X,Y));
end;

procedure TForm2.ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  MousePoint: TPoint;
  ARect: TRect;
begin
  if Shift = [ssLeft] then
  begin
    MousePoint := Self.ClientToScreen(Point(X,Y)); // 화면을 기준으로 클라이언트의 좌표

    if (MousePoint.X < FDockUnit.MultiSelection.ClickPoint.X) or (MousePoint.Y < FDockUnit.MultiSelection.ClickPoint.Y) then
      ARect := Rect(Point(MousePoint.X, MousePoint.Y), Point(FDockUnit.MultiSelection.ClickPoint.X, FDockUnit.MultiSelection.ClickPoint.Y))
    else
      ARect := Rect(Point(FDockUnit.MultiSelection.ClickPoint.X, FDockUnit.MultiSelection.ClickPoint.Y),Point(MousePoint.X, MousePoint.Y));

    FDockUnit.MultiSelection.BoundsRect := ARect;
  end;
end;

procedure TForm2.ScrollBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDockUnit.DockInTheSelection;
end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
//  FDockUnit.ZoomIn := TrackBar1.Position;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;
finalization

end.
