unit ResourceUtils;

interface
  uses MMSYSTEM, System.Classes, System.SysUtils, Winapi.Windows;

  type
    TResourceUtils = class
    private
    public
      constructor Create;
      destructor Destroy; override;
    end;

  procedure ClickSound;

implementation

procedure ClickSound;
var
  ResourceStream: TResourceStream;
begin
  ResourceStream := TResourceStream.Create(HInstance, 'CLICK2', PChar('WAV'));
  try
    sndPlaySound(ResourceStream.Memory, SND_MEMORY or SND_ASYNC);
  finally
    ResourceStream.Free;
  end;
end;

{ TResourceUtils }

constructor TResourceUtils.Create;
begin

end;

destructor TResourceUtils.Destroy;
begin

  inherited;
end;

end.
