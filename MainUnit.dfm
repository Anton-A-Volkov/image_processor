object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Image Processor'
  ClientHeight = 450
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object pnlGetDirectory: TPanel
    Left = 0
    Top = 0
    Width = 554
    Height = 81
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 1052
    DesignSize = (
      554
      81)
    object eFolderPath: TLabeledEdit
      Left = 16
      Top = 30
      Width = 511
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 103
      EditLabel.Height = 15
      EditLabel.Caption = 'Folder with images:'
      TabOrder = 0
      Text = ''
      ExplicitWidth = 1009
    end
    object btnSelectFolder: TButton
      Left = 494
      Top = 30
      Width = 33
      Height = 23
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
      OnClick = btnSelectFolderClick
      ExplicitLeft = 992
    end
  end
  object pcWorkspace: TPageControl
    Left = 0
    Top = 81
    Width = 554
    Height = 208
    ActivePage = tsResize
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 1052
    ExplicitHeight = 479
    object tsResize: TTabSheet
      Caption = 'Resize'
      object eNewWidth: TLabeledEdit
        Left = 12
        Top = 40
        Width = 205
        Height = 23
        EditLabel.Width = 78
        EditLabel.Height = 15
        EditLabel.Caption = 'New width, px:'
        TabOrder = 0
        Text = ''
      end
      object LabeledEdit1: TLabeledEdit
        Left = 12
        Top = 112
        Width = 205
        Height = 23
        EditLabel.Width = 82
        EditLabel.Height = 15
        EditLabel.Caption = 'New height, px:'
        TabOrder = 1
        Text = ''
      end
      object btnResize: TButton
        Left = 240
        Top = 71
        Width = 75
        Height = 25
        Caption = 'GO!'
        TabOrder = 2
      end
    end
  end
  object pnlLog: TPanel
    Left = 0
    Top = 289
    Width = 554
    Height = 161
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 560
    ExplicitWidth = 1052
    DesignSize = (
      554
      161)
    object ProgressBar1: TProgressBar
      Left = 16
      Top = 8
      Width = 511
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 1009
    end
    object memLog: TMemo
      Left = 16
      Top = 40
      Width = 511
      Height = 105
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
      ExplicitWidth = 1009
    end
  end
  object dlgSelectFolder: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    OkButtonLabel = 'Select'
    Options = [fdoPickFolders, fdoPathMustExist, fdoDontAddToRecent]
    Title = 'Select folder with images'
    Left = 88
    Top = 64
  end
end
