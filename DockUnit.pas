unit DockUnit;

interface
  uses DockingUtils, Animation, DockMultipleSelections,
  VCL.Controls, VCL.Graphics, System.Classes, System.SysUtils, System.Types, Winapi.Windows, System.Generics.Collections, Winapi.Messages,
  VCL.Forms, System.Math;

  type
    TSelectState = (ssClick, ssUnClick, ssTogle);
    TSex = (Men, Women);
    TBorderStyle = (bsGradient, bsSolid);

    TDockUnit = class;

    TDockUnit = class(TCustomControl)
    protected
      property OnStartDock;
      property OnDockOver;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
    private
      FSex: TSex;
      FClickPoint: TPoint;
      FZoomIn: integer;
      FControlState: TControlState;
      FBorderStyle: TBorderStyle;
      FSelectState: TSelectState;

      procedure UnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
      procedure DockOver(Sender: TObject; Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
      procedure StartDock(Sender: TObject; var DragObject: TDragDockObject);
      procedure GetSiteInfo(Sender: TObject; DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);

      procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

      procedure Dock(NewDockSite: TWinControl; ARect: TRect); override;
      //
      function ShowingDockingRect(var DockRect: TRect; MousePos: TPoint): TAlign; inline;

      procedure PaintTheBackGround(Color: TColor);
      procedure PaintTheText(S: String);

      procedure CMDockClient(var Message: TCMDockClient); message CM_DOCKCLIENT;
      procedure Zoom;

      function GetSelectState: TSelectState;
      procedure SetSelectState(const Value: TSelectState);
      function GetSex: TSex;
      procedure SetSex(const Value: TSex);
      procedure SetBorderStyle(const Value: TBorderStyle);
      function GetZoomIn: integer;
      procedure SetZoomIn(const Value: integer);

      property Sex: TSex read GetSex write SetSex;
      property BorderStyle: TBorderStyle write SetBorderStyle;
    public
      procedure Paint; override;

      constructor Create(AOwner: TComponent);
      destructor Destroy; override;

      property SelectState: TSelectState read GetSelectState write SetSelectState default ssUnClick;
      property ZoomIn: integer read GetZoomIn write SetZoomIn;
    end;

implementation

const
  DOCKSIZE = 50;
{ TDockUnit }

procedure TDockUnit.PaintTheBackGround(Color: TColor);
var
  ARect: TRect;
  R,G,B: Byte;
  EndR, EndG, EndB: Byte;
  i: Integer;
begin
  ARect := ClientRect;

  DrawEdge(Canvas.Handle, ARect, BDR_SUNKENOUTER, BF_RECT);
  case FBorderStyle of
    bsGradient:
    begin
      EndR := GetRValue(Color);
      EndG := GetGValue(Color) + 75;
      EndB := GetBValue(Color) + 75;

      for i := 0 to ClientWidth -1 do
      begin
        R := MulDiv(i, EndR - GetRValue(Color), ClientWidth);
        G := MulDiv(i, EndG - GetGValue(Color), ClientWidth);
        B := MulDiv(i, EndB - GetBValue(Color), ClientWidth);

        ARect.Right := i;
        Canvas.Brush.Color := RGB(EndR + R, EndG + G, EndB + B);
        Canvas.FillRect(ARect);

        ARect.Left := i;
      end;
    end;
    bsSolid:
    begin

    end;
  end;

  ARect := ClientRect;
  DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_BOTTOMRIGHT);

  case SelectState of
    ssClick :
    begin
      Canvas.Rectangle(ARect.Left, ARect.Top, ARect.Width, ARect.Height);
//      Canvas.DrawFocusRect(ARect);
    end;
    ssUnClick :
  end;
end;

procedure TDockUnit.PaintTheText(S: String);
var
//  TextHeight, TextWidth, TextLeft, TextTop: Integer;
  ARect: TRect;
  TextSize: TSize;
begin
  // 이름넣기
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Style := psClear;

  ARect := ClientRect;

  // 번호
  Canvas.Font.Size := 8;
  TextSize := Canvas.TextExtent(S);
  Canvas.TextOut(ARect.Left + 5, ARect.Top + 2 ,'100');
  // 이름
  Canvas.Font.Size := 15;
  TextSize := Canvas.TextExtent(S);
  Canvas.TextOut(Round((ARect.Width - TextSize.Width)/2), Round((ARect.Height - TextSize.Height)/2) ,S);
end;

procedure TDockUnit.CMDockClient(var Message: TCMDockClient);
var
  DockType: TAlign;
  MousePoint: TPoint;
  DockUnit: TDockUnit;
  ARect: TRect;
const
  DELAY = 100;
begin
  if Message.DockSource.Control is TDockUnit then
  begin
    TDockUnit(Message.DockSource.Control).Visible := False;

    MousePoint := Point(Message.MousePos.X, Message.MousePos.Y);
    DockType := ShowingDockingRect(ARect, MousePoint);

    ARect.Width := Width;
    ARect.Height := Height;

    case DockType of
      alLeft:
      begin
        Message.DockSource.Control.Left := Left - Width;
        Message.DockSource.Control.Top := Top;
      end;
      alTop:
      begin
        Message.DockSource.Control.Left := Left;
        Message.DockSource.Control.Top := Top - Height;
      end;
      alRight:
      begin
        Message.DockSource.Control.Left := Left + Width;
        Message.DockSource.Control.Top := Top;
      end;
      alBottom:
      begin
        Message.DockSource.Control.Left := Left;
        Message.DockSource.Control.Top := Top + Height;
      end;
    end;
    TAnimation.CenterSlideShow(TDockUnit(Message.DockSource.Control));
  end;
  // Note: 루프를 강제종료시 박스가 사라지는 현상 발생
end;

constructor TDockUnit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // DockList에서 관리
  Parent := TWinControl(AOwner);
  Randomize;
  Left := Random(Parent.Width);
  Top := Random(Parent.Height);

  Width := DOCKSIZE;
  Height := DOCKSIZE;
  BorderWidth := 1;

  DragMode := dmManual;
  DragKind := dkDock;
  DockSite := True;

  ParentColor := False;
  DoubleBuffered := True;

  OnDockOver := DockOver;
  OnStartDock := StartDock;
  OnUnDock := UnDock;
  OnGetSiteInfo := GetSiteInfo;
  OnMouseDown := MouseDown;

  SelectState := ssUnClick;
end;

destructor TDockUnit.Destroy;
begin
  inherited;
end;

procedure TDockUnit.Dock(NewDockSite: TWinControl; ARect: TRect);
var
  MousePoint: TPoint;
begin

  MousePoint.X := Mouse.CursorPos.X;
  MousePoint.Y := Mouse.CursorPos.Y;
  // 해당 컴포넌트 클릭좌표를 알아서 정확히 계산하기
  MousePoint := Parent.ScreenToClient(MousePoint);
  // 화면밖으로 나가지 않게
  if PtInRect(Parent.ClientRect,Point(MousePoint.X,MousePoint.Y)) then
  begin
    Self.Left := MousePoint.X - FClickPoint.X;
    Self.Top := MousePoint.Y - FClickPoint.Y;
  end;
end;

procedure TDockUnit.DockOver(Sender: TObject; Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  ARect: TRect;
begin
  // Note : Sender는 옮기는 대상 Source는 생성한 Transparent 객체
  Accept := (Source.Control is TDockUnit);

  //Draw dock preview depending on where the cursor is relative to our client area
  if Accept and (ShowingDockingRect(ARect, Point(X,Y)) <> alNone) then
  begin
    ShowingDockingRect(ARect, Point(X,Y));
    Source.DockRect := ARect;
  end;
end;

function TDockUnit.GetSelectState: TSelectState;
begin
  Result := FSelectState;
end;

function TDockUnit.GetSex: TSex;
begin
  Result := FSex;
end;

procedure TDockUnit.GetSiteInfo(Sender: TObject; DockClient: TControl; var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
begin
  CanDock:= DockClient is TDockUnit;
end;

function TDockUnit.GetZoomIn: integer;
begin
  Result := FZoomIn;
end;

procedure TDockUnit.MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Shift = [ssLeft] then
  begin
    BeginDrag(False); // DragMode = dmManual 일때 드래그가 가능하게 변경
  end
  else if Shift = [ssLeft, ssDouble] then
  begin
    // 편집창 띄워주기
  end
  else if Shift = [ssCtrl, ssLeft] then
  begin
    SelectState := ssTogle;
  end;
end;

procedure TDockUnit.Paint;
begin
  inherited;
//  Zoom;
  Canvas.Lock;
  try
    PaintTheBackGround(clRed);
    PaintTheText('안녕하세요');
  finally
    Canvas.Unlock;
  end;
end;

procedure TDockUnit.SetBorderStyle(const Value: TBorderStyle);
begin
  FBorderStyle := Value;
  Repaint;
end;

procedure TDockUnit.SetSelectState(const Value: TSelectState);
begin
  if Value = ssTogle then
  begin
    if FSelectState = ssClick then
      FSelectState := ssUnClick
    else if FSelectState = ssUnClick then
      FSelectState := ssClick;
  end
  else
    FSelectState := Value;

  Repaint;
end;

procedure TDockUnit.SetSex(const Value: TSex);
begin
  FSex := Value;
  Repaint;
end;

procedure TDockUnit.SetZoomIn(const Value: integer);
var
  ARect: TRect;
begin
//  if FZoomIn > Value then
//  begin
//    Width := DockUnitSize * Value;
//    Height := DockUnitSize * Value;
//    Left := Left - Width;
//    Top := Top - Height;
//  end
//  else
//  begin
//    Width := DockUnitSize * Value;
//    Height := DockUnitSize * Value;
//    Left := Left + Width;
//    Top := Top + Height;
//  end;

  FZoomIn := Value;
//  Repaint;
end;

function TDockUnit.ShowingDockingRect(var DockRect: TRect; MousePos: TPoint): TAlign;
const
  INTERVAL = 10; // 간격
  RATIO = 5; // 비율
var
  DockTopRect,
  DockLeftRect,
  DockBottomRect,
  DockRightRect: TRect;
begin
  Result := alNone;

  DockLeftRect.TopLeft := Point(0, 0);
  DockLeftRect.BottomRight := Point(ClientWidth div RATIO, ClientHeight);

  DockRightRect.TopLeft := Point(ClientWidth div RATIO * 4, 0);
  DockRightRect.BottomRight := Point(ClientWidth, ClientHeight);

  DockTopRect.TopLeft := Point(0, 0);
  DockTopRect.BottomRight := Point(ClientWidth, ClientHeight div RATIO);

  DockBottomRect.TopLeft := Point(0, ClientHeight div RATIO * 4);
  DockBottomRect.BottomRight := Point(ClientWidth, ClientHeight);

  //Find out where the mouse cursor is, to decide where to draw dock preview.
  if PtInRect(DockLeftRect, MousePos) then
  begin
    Result := alLeft;
    DockRect := DockLeftRect;
  end
  else if PtInRect(DockTopRect, MousePos) then
  begin
    Result := alTop;
    DockRect := DockTopRect;
  end
  else if PtInRect(DockRightRect, MousePos) then
  begin
    Result := alRight;
    DockRect := DockRightRect;
  end
  else if PtInRect(DockBottomRect, MousePos) then
  begin
    Result := alBottom;
    DockRect := DockBottomRect;
  end
  else if Result = alNone then Exit;

  //DockRect is in screen coordinates.

  DockRect.TopLeft := ClientToScreen(DockRect.TopLeft);
  DockRect.BottomRight := ClientToScreen(DockRect.BottomRight);

  SetFocus;
end;

procedure TDockUnit.StartDock(Sender: TObject; var DragObject: TDragDockObject);
begin
  FClickPoint := TDockUnit(Sender).ScreenToClient(Mouse.CursorPos);
  DragObject := TTransparentDragDockObject.Create(Self);
  SetFocus;
end;

procedure TDockUnit.UnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin
  if Client is TDockUnit then
    TDockUnit(Client).DockSite := True;

  if (DockClientCount = 2) and (NewTarget <> Self) then
    PostMessage(Self.Handle, WM_CLOSE, 0, 0);
end;

procedure TDockUnit.Zoom;
var
  form: tagXFORM;
  rAngle: Double;
begin
  rAngle := DegToRad(0);
  SetGraphicsMode(Canvas.Handle, GM_ADVANCED);
  SetMapMode(Canvas.Handle, MM_ANISOTROPIC);
  form.eM11 := ZoomIn * Cos(rAngle);
  form.eM12 := ZoomIn * Sin(rAngle);
  form.eM21 := ZoomIn * (-Sin(rAngle));
  form.eM22 := ZoomIn * Cos(rAngle);
  form.eDx := 0;
  form.eDy := 0;
  SetWorldTransform(Canvas.Handle, form);
end;

end.
