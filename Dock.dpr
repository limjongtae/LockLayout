program Dock;







{$R 'Resource.res' 'Resource.rc'}

uses
  Vcl.Forms,
  Dock.FormView in 'Dock.FormView.pas' {Form2},
  DockUnit in 'DockUnit.pas',
  DockingUtils in 'DockingUtils.pas',
  DockMultipleSelections in 'DockMultipleSelections.pas',
  Animation in 'Animation.pas',
  ResourceUtils in 'ResourceUtils.pas',
  DockList in 'DockList.pas';

{$R *.res}
{$R Resource.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
