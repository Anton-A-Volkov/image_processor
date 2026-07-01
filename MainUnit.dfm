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
    Height = 101
    Align = alTop
    TabOrder = 0
    DesignSize = (
      554
      101)
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
    end
    object cbRewriteExisting: TCheckBox
      Left = 16
      Top = 68
      Width = 511
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Rewrite existing files with processed images'
      TabOrder = 2
    end
  end
  object pcWorkspace: TPageControl
    Left = 0
    Top = 101
    Width = 554
    Height = 188
    ActivePage = tsResize
    Align = alClient
    TabOrder = 1
    OnChange = pcWorkspaceChange
    object tsResize: TTabSheet
      Caption = 'Resize'
      object btnLockDimensions: TSpeedButton
        Left = 189
        Top = 40
        Width = 24
        Height = 24
        AllowAllUp = True
        GroupIndex = 1
        Down = True
        ImageIndex = 1
        Images = ilIcons
        Flat = True
        OnClick = btnLockDimensionsClick
      end
      object lblResizeDescription: TLabel
        Left = 16
        Top = 112
        Width = 505
        Height = 41
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'Resizes images with preserving aspect ratio to fit one of the di' +
          'mensions.'
        Layout = tlCenter
      end
      object eNewWidth: TLabeledEdit
        Left = 12
        Top = 40
        Width = 170
        Height = 23
        EditLabel.Width = 78
        EditLabel.Height = 15
        EditLabel.Caption = 'New width, px:'
        TabOrder = 0
        Text = '1024'
        OnChange = eNewWidthChange
      end
      object eNewHeight: TLabeledEdit
        Left = 219
        Top = 40
        Width = 170
        Height = 23
        EditLabel.Width = 82
        EditLabel.Height = 15
        EditLabel.Caption = 'New height, px:'
        TabOrder = 1
        Text = '1024'
        OnChange = eNewHeightChange
      end
      object btnResize: TButton
        Left = 448
        Top = 39
        Width = 75
        Height = 25
        Caption = 'GO!'
        TabOrder = 2
        OnClick = btnResizeClick
      end
    end
    object tsMakeICO: TTabSheet
      Caption = 'Make Windows ICOn'
      ImageIndex = 1
      DesignSize = (
        546
        158)
      object eICOSaveFile: TLabeledEdit
        Left = 12
        Top = 32
        Width = 511
        Height = 23
        EditLabel.Width = 73
        EditLabel.Height = 15
        EditLabel.Caption = 'Save result to:'
        TabOrder = 0
        Text = ''
      end
      object btnSelectResultFile: TButton
        Left = 502
        Top = 38
        Width = 33
        Height = 23
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = btnSelectResultFileClick
      end
      object cbICOFilterUniqueSizes: TCheckBox
        Left = 16
        Top = 72
        Width = 507
        Height = 17
        Caption = 'Filter unique sizes'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object btnMakeICO: TButton
        Left = 16
        Top = 112
        Width = 137
        Height = 25
        Caption = 'Make Windows ICOn'
        TabOrder = 3
        OnClick = btnMakeICOClick
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
    DesignSize = (
      554
      161)
    object pbProgress: TProgressBar
      Left = 16
      Top = 8
      Width = 511
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object memLog: TMemo
      Left = 16
      Top = 40
      Width = 511
      Height = 105
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object dlgSelectFolder: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'BMP image'
        FileMask = '*.bmp'
      end
      item
        DisplayName = 'PNG image'
        FileMask = '*.png'
      end
      item
        DisplayName = 'JPG image'
        FileMask = '*.jpg;*.jpeg'
      end
      item
        DisplayName = 'GIF image'
        FileMask = '*.gif'
      end>
    OkButtonLabel = 'Select'
    Options = [fdoPickFolders, fdoPathMustExist, fdoDontAddToRecent]
    Title = 'Select folder with images'
    Left = 72
    Top = 56
  end
  object ilIcons: TPngImageList
    DrawingStyle = dsTransparent
    Height = 24
    Width = 24
    PngImages = <
      item
        Background = clWindow
        Name = 'unlock'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F80000000970485973000000B1000000B101C62D498D0000001974455874536F
          667477617265007777772E696E6B73636170652E6F72679BEE3C1A0000017F49
          44415478DAB5D53D2845611CC7F1FF951B91B2582D9497C180B250949451090B
          83D120512292643020773788E552368B288981BC65F056D7C462B3B888E2FBEF
          79D4EDEA5CCF39CE7DEAD3399DF3DCE7F7DCF3BC4524CB25E2A35E13EAF0894B
          1CE02B8C8032C4519FF6FC025D48FC27A0046728C218B690443B1690831A3C05
          0D8861008D384E7B5761FFC58AAD1328E01127E8F078DF29661C36830444F18E
          194C4BC09229201FAF18C75CD801AD68C604F671F4473B6F38C4AE4B80CE8E61
          FB79928E1D2D401E16319229A012D758C2A89845E55272318F4154E1CE2BA05B
          CCA2D24AB78E8DA776EE063D58F70AE8C52ACA71EF334057BCAEEA3EAC050D88
          DAEB4736024A712A6661E9BEF41076401BB653EE77C20ED0BAE7F6BE567E6FD5
          A18CC19EBDB664630CB4C46CCF878206E801A273B85ACC9CF653F4375762D6D2
          865780F65C57E1B298EDE2C5B1F14231ABBF5FCC3991F00AD0A2DBF3A4B89FD7
          3F453FDD2CA6521F7A35D22066208B1D1B7F163301D24F3DDFBDF45DBE017AE7
          6019F029201F0000000049454E44AE426082}
      end
      item
        Background = clWindow
        Name = 'lock'
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F8000000097048597300000B1200000B1201D2DD7EFC0000001974455874536F
          667477617265007777772E696E6B73636170652E6F72679BEE3C1A0000019049
          44415478DAAD95CB2B45411CC77F37AF1465637153EEB550B2656363C14679DC
          85D756926B4BB1743D164A9225297F801B11B221C94216B6521644BAB662E315
          DF5FF393D375E79C9939E7579FCE348FF3393367E63731328F0AD020E56BF06A
          322866D0270E16413F2893BA37B009A6C05318411D3803E5601D5C4A7D331895
          59B4825B1701B75D806A79C9435E7B029CCA0C5AC0B7ADA01D1C811EB0A7E993
          023BA00D9CD80AE6658DF9E77E68FA94CA322D808CAD6055BE304EFE9103BB60
          CC56B006BA404D80E011EC83B4A980A7DD04E6E49926FFE00FE1DD352DCF773F
          41121C8046728B2BD009EE7402DE2DBCE546E8FFB60C8A5A5267E51C74EB042F
          A47EEEA4E30C96482D69A54EC0876516CC380A785CC6FB5E1B01F71D96F20615
          3EB9A1047D202BE55EB01DB580D3C1B1A75C2835841214D35FCA28019F510B8A
          48DD031C7C2F7C452DE018903E594D7B684150040A9E496DC17147C10A180255
          3A01DFB31D60823CF9C4309260191C82419D8073FF16A97CE4129C87F88CE474
          82DFBA7A52C9CB26EEC10DE59DF01FE9625E19553D1A330000000049454E44AE
          426082}
      end>
    Left = 400
    Top = 56
    Bitmap = {}
  end
  object dlgSaveFile: TFileSaveDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoOverWritePrompt, fdoPathMustExist, fdoShareAware]
    Title = 'Seve result as ...'
    Left = 288
    Top = 64
  end
end
