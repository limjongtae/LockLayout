unit Animation;

interface
   uses ResourceUtils,
   Winapi.Windows, VCL.Controls;

   type
     TAnimation = class
     class var
       const DELAY = 100;
     public
       class procedure CenterSlideShow(Sender: TCustomControl);
     end;

implementation

{ TAnimation }

class procedure TAnimation.CenterSlideShow(Sender: TCustomControl);
begin
  ClickSound;

  if TCustomControl(Sender).Visible then
    TCustomControl(Sender).Visible := False;

  try
    AnimateWindow(TCustomControl(Sender).Handle, DELAY, AW_CENTER or AW_SLIDE or AW_ACTIVATE);
  finally
    if not TCustomControl(Sender).Visible then
      TCustomControl(Sender).Visible := True;
  end;
  // Âü°í https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-animatewindow
end;

end.
