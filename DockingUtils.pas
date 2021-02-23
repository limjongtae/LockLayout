unit DockingUtils;

interface

uses
  Classes, Windows, SysUtils, Graphics, Controls, ExtCtrls, Forms;

type
  TTransparentForm = class(TForm)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TTransparentDragDockObject = class(TDragDockObjectEx)
  protected
    function GetEraseWhenMoving: Boolean; override;
    procedure DrawDragDockImage; override;
    procedure EraseDragDockImage; override;
  public
    constructor Create(AControl: TControl); override;
    destructor Destroy; override;
  end;

implementation

var
  TransparentForm: TTransparentForm;
  AlphaBlendValue: Integer = 100;

{ TTransparentForm }

procedure TTransparentForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle:= Params.ExStyle or WS_EX_TRANSPARENT;
end;

{ TTransparentDragDockObject }

constructor TTransparentDragDockObject.Create(AControl: TControl);
begin
  inherited;
  if TransparentForm = nil then
  begin
    TransparentForm:= TTransparentForm.CreateNew(Application);
    TransparentForm.AlphaBlend:= True;
    TransparentForm.AlphaBlendValue:= AlphaBlendValue;
    TransparentForm.BorderStyle:= bsNone;
    TransparentForm.Color:= clHighlight;
    TransparentForm.FormStyle:= fsStayOnTop;
  end;
end;

procedure TTransparentDragDockObject.EraseDragDockImage;
begin
  TransparentForm.Hide;
end;

destructor TTransparentDragDockObject.Destroy;
begin
  inherited;
end;

procedure TTransparentDragDockObject.DrawDragDockImage;
begin
  if TransparentForm <> nil then
  begin
    TransparentForm.BoundsRect:= DockRect;
    if not TransparentForm.Visible then
      TransparentForm.Show;
  end;
end;

function TTransparentDragDockObject.GetEraseWhenMoving: Boolean;
begin
  Result:= False;
end;

end.
