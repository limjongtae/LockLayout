unit DockList;

interface
  uses DockUnit, DockMultipleSelections,
  VCL.Controls, VCL.Graphics, System.Classes, System.SysUtils, System.Types, Winapi.Windows, System.Generics.Collections, Winapi.Messages,
  VCL.Forms, System.Math;

  type
    TDockList = class
    private
      FOwner: TComponent;
      FZoomIn: integer;
      FDockUnit: TList<TDockUnit>;
      FMultiSelection: TDockMultipleSelect;
    procedure SetZoomIn(const Value: integer);
    public
      procedure Add; overload;
      procedure Add(Dock: TDockUnit); overload;

      procedure Clear; reintroduce;
      procedure Refresh;

      constructor Create(AOwner: TWinControl);
      destructor Destroy; override;

      procedure DockInTheSelection;

      property MultiSelection: TDockMultipleSelect read FMultiSelection write FMultiSelection;
      property ZoomIn: integer write SetZoomIn;
    end;

implementation

{ TDockList }

procedure TDockList.Add;
var
  DockUnit: TDockUnit;
begin
  DockUnit := TDockUnit.Create(FOwner);
//  DockUnit.Parent := TWinControl(FOwner);
//  ReleaseDC(DockUnit.Handle, GetDC(DockUnit.Parent.Handle));
  FDockUnit.Add(DockUnit);
end;

procedure TDockList.Add(Dock: TDockUnit);
begin
//  Dock.Parent := TWinControl(FOwner);
//  ReleaseDC(Dock.Handle, GetDC(Dock.Parent.Handle));
  FDockUnit.Add(Dock);
end;

procedure TDockList.Clear;
var
  i: Integer;
begin
  LockWindowUpdate(TWinControl(FOwner).Handle);
  try
    for i := 0 to FDockUnit.Count - 1 do
      FDockUnit[i].Free;

    FDockUnit.Clear;
  finally
    LockWindowUpdate(0);
  end;
end;

constructor TDockList.Create(AOwner: TWinControl);
begin
  FDockUnit := TList<TDockUnit>.Create;
  FMultiSelection := TDockMultipleSelect.Create(AOwner);
  FOwner := AOwner;
end;

destructor TDockList.Destroy;
begin
  Clear;

  FMultiSelection.Free;
  FDockUnit.Free;
  inherited;
end;

procedure TDockList.DockInTheSelection;
  function ClientToScreen(Sender: TControl): TRect; inline;
  var
    Origin: TPoint;
    OriginRect: TRect;
  begin
    OriginRect := TControl(Sender).ClientRect;
    Origin := TControl(Sender).ClientOrigin;

    Result.TopLeft := Point(OriginRect.Top + Origin.Y, OriginRect.Left + Origin.X);
    Result.BottomRight := Point(OriginRect.Bottom + Origin.Y, OriginRect.Right + Origin.X);
  end;
var
  i: Integer;
  SRect, DRect, RRect: TRect;
  DockUnit: TDockUnit;
begin
  // 선택영역이 좀 문제가 있는거 같은데 차차 확인해보자

  LockWindowUpdate(Application.Handle);
  try
    for i := 0 to FDockUnit.Count - 1 do
    begin

  //    SRect.TopLeft := ClientToScreen(TControl(MultiSelection).ClientRect.TopLeft, MultiSelection);
  //    SRect.BottomRight := ClientToScreen(TControl(MultiSelection).ClientRect.BottomRight, MultiSelection);
  //
  //    DRect.TopLeft := ClientToScreen(TControl(FDockUnit[i]).ClientRect.TopLeft, FDockUnit[i]);
  //    DRect.BottomRight := ClientToScreen(TControl(FDockUnit[i]).ClientRect.BottomRight, FDockUnit[i]);
      if IntersectRect(RRect, ClientToScreen(FDockUnit[i]), ClientToScreen(MultiSelection)) then
  //    if IntersectRect(RRect, DRect, SRect) then
        FDockUnit[i].SelectState := ssClick
      else FDockUnit[i].SelectState := ssUnClick;
    end;
  finally
    LockWindowUpdate(0);
    MultiSelection.Hide;
  end;
end;

procedure TDockList.Refresh;
var
  i: Integer;
begin
  LockWindowUpdate(TWinControl(FOwner).Handle);
  try
    for i := 0 to FDockUnit.Count -1 do
      FDockUnit[i].Repaint;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TDockList.SetZoomIn(const Value: integer);
var
  i: integer;
begin
  FZoomIn := Value;

  LockWindowUpdate(TWinControl(FOwner).Handle);
  try
    for i := 0 to FDockUnit.Count -1 do
      FDockUnit[i].ZoomIn := Value;
  finally
    LockWindowUpdate(0);
  end;
end;

end.
