unit DockMultipleSelections;

interface
  uses
  VCL.Controls, VCL.Forms, VCL.Graphics, Winapi.Windows, Winapi.Messages, System.Classes;

  type
    TDockMultipleSelect = class(TForm)
    protected
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;

      procedure CreateParams(var Params: TCreateParams); override;
    private
      FClickPoint: TPoint;
      FOwner: TWinControl;

      function GetClickPoint: TPoint;
      procedure SetClickPoint(const Value: TPoint);

      procedure Activate; override;
      procedure FocusControl(Control: TWinControl);
      procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
      procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    public
      constructor Create(AOwner: TWinControl);
      destructor Destroy; override;

      procedure Hide;
      procedure Clear;

      property ClickPoint: TPoint read GetClickPoint write SetClickPoint;
    end;

implementation

{ TDockMultipleSelect }

procedure TDockMultipleSelect.Activate;
begin
//  ActiveControl := nil;
  FocusControl(nil);
end;

procedure TDockMultipleSelect.Clear;
begin
  BoundsRect := TRect.Empty;
  FClickPoint := Point(0,0);
end;

constructor TDockMultipleSelect.Create(AOwner: TWinControl);
var
  MousePoint: TPoint;
begin
  CreateNew(AOwner);
  FOwner := AOwner;

  AlphaBlend:= True;
  AlphaBlendValue:= 100;
  BorderStyle:= bsNone;
  Color:= clHighlight;
  FormStyle:= fsStayOnTop;
  DoubleBuffered := True;
  Visible := False;

//  MousePoint.X := Mouse.CursorPos.X;
//  MousePoint.Y := Mouse.CursorPos.Y;
//  // 해당 컴포넌트 클릭좌표를 알아서 정확히 계산하기
//  MousePoint := Parent.ScreenToClient(MousePoint);
//
//  ClickPoint := Point(MousePoint.X, MousePoint.Y);
end;

procedure TDockMultipleSelect.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle:= Params.ExStyle or WS_EX_TRANSPARENT;
end;

destructor TDockMultipleSelect.Destroy;
begin
  inherited;
end;

procedure TDockMultipleSelect.FocusControl(Control: TWinControl);
begin
  Winapi.Windows.SetFocus(FOwner.Handle);
end;

function TDockMultipleSelect.GetClickPoint: TPoint;
begin
  Result := FClickPoint;
end;

procedure TDockMultipleSelect.Hide;
begin
  Clear;

  if Visible then
    Visible := False;
end;

procedure TDockMultipleSelect.SetClickPoint(const Value: TPoint);
begin
  Visible := True;
  FClickPoint := Value;
end;

procedure TDockMultipleSelect.WMLButtonDown(var Message: TWMLButtonDown);
begin
  FClickPoint.X := Message.XPos;
end;

procedure TDockMultipleSelect.WMMouseMove(var Message: TWMMouseMove);
begin
  FClickPoint.X := Message.XPos;
end;

end.
