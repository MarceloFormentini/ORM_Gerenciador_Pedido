object FPedido: TFPedido
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Pedido'
  ClientHeight = 472
  ClientWidth = 678
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 678
    Height = 472
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object PanelPedido: TPanel
        Left = 0
        Top = 0
        Width = 670
        Height = 403
        Align = alClient
        TabOrder = 0
        object Label1: TLabel
          Left = 7
          Top = 55
          Width = 72
          Height = 13
          Caption = 'Numero Pedido'
        end
        object Shape: TShape
          Left = 0
          Top = 96
          Width = 654
          Height = 4
          Brush.Color = clAqua
        end
        object Label5: TLabel
          Left = 1
          Top = 1
          Width = 668
          Height = 21
          Align = alTop
          Alignment = taCenter
          Caption = 'Pedido'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 54
        end
        object Label2: TLabel
          Left = 27
          Top = 131
          Width = 52
          Height = 13
          Caption = 'Refer'#234'ncia'
        end
        object Label3: TLabel
          Left = 15
          Top = 163
          Width = 64
          Height = 13
          Caption = 'Data Emiss'#227'o'
        end
        object Label4: TLabel
          Left = 46
          Top = 195
          Width = 33
          Height = 13
          Caption = 'Cliente'
        end
        object btnPesquisa: TButton
          Left = 212
          Top = 51
          Width = 21
          Height = 21
          Hint = 'Pesquisar Pedido'
          ImageIndex = 0
          Images = ImageList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TabStop = False
          OnClick = btnPesquisaClick
        end
        object DataEmissao: TDateTimePicker
          Left = 85
          Top = 160
          Width = 121
          Height = 21
          Date = 45777.000000000000000000
          Time = 0.572418912037392100
          TabOrder = 3
        end
        object RadioGroup1: TRadioGroup
          Left = 85
          Top = 224
          Width = 569
          Height = 97
          Caption = 'Tipo Opera'#231#227'o'
          ItemIndex = 1
          Items.Strings = (
            'Entrada'
            'Saida')
          TabOrder = 7
        end
        object EditNumeroPedido: TEdit
          Left = 85
          Top = 51
          Width = 121
          Height = 21
          TabOrder = 0
          OnKeyPress = EditNumeroPedidoKeyPress
        end
        object EditReferencia: TEdit
          Left = 85
          Top = 128
          Width = 569
          Height = 21
          CharCase = ecUpperCase
          MaxLength = 100
          TabOrder = 2
        end
        object EditCodigoCliente: TEdit
          Left = 85
          Top = 192
          Width = 121
          Height = 21
          TabOrder = 4
          OnKeyPress = EditCodigoClienteKeyPress
        end
        object EditNomeCliente: TEdit
          Left = 212
          Top = 192
          Width = 416
          Height = 21
          TabStop = False
          CharCase = ecUpperCase
          Enabled = False
          ReadOnly = True
          TabOrder = 5
        end
        object btnPesquisaCliente: TButton
          Left = 633
          Top = 192
          Width = 21
          Height = 21
          Hint = 'Pesquisar Cliente'
          ImageIndex = 0
          Images = ImageList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          TabStop = False
          OnClick = btnPesquisaClienteClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 403
        Width = 670
        Height = 41
        Align = alBottom
        TabOrder = 1
        ExplicitLeft = 1
        ExplicitTop = 409
        object btnFechar: TButton
          Left = 15
          Top = 6
          Width = 120
          Height = 25
          Caption = 'Fechar'
          TabOrder = 0
          OnClick = btnFecharClick
        end
        object btnAvancar: TButton
          Left = 534
          Top = 6
          Width = 120
          Height = 25
          Caption = 'Avan'#231'ar'
          TabOrder = 2
          OnClick = btnAvancarClick
        end
        object btnNovo: TButton
          Left = 275
          Top = 6
          Width = 120
          Height = 25
          Caption = 'Novo'
          TabOrder = 1
          OnClick = btnNovoClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 362
        Width = 670
        Height = 41
        Align = alBottom
        TabOrder = 0
        object Label7: TLabel
          Left = 503
          Top = 14
          Width = 59
          Height = 13
          Caption = 'Total Pedido'
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object EditTotalPedido: TEdit
          Left = 565
          Top = 11
          Width = 90
          Height = 21
          TabStop = False
          Alignment = taRightJustify
          Enabled = False
          ReadOnly = True
          TabOrder = 0
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 403
        Width = 670
        Height = 41
        Align = alBottom
        TabOrder = 1
        object btnVoltar: TButton
          Left = 15
          Top = 6
          Width = 120
          Height = 25
          Caption = 'Voltar'
          TabOrder = 0
          OnClick = btnVoltarClick
        end
        object btnSalvar: TButton
          Left = 534
          Top = 8
          Width = 120
          Height = 25
          Caption = 'Salvar'
          TabOrder = 1
          OnClick = btnSalvarClick
        end
        object btnExcluir: TButton
          Left = 275
          Top = 6
          Width = 120
          Height = 25
          Caption = 'Excluir'
          TabOrder = 2
          OnClick = btnExcluirClick
        end
      end
      object TPanel
        Left = 0
        Top = 0
        Width = 670
        Height = 125
        Align = alTop
        TabOrder = 2
        object Label8: TLabel
          Left = 24
          Top = 16
          Width = 38
          Height = 13
          Caption = 'Produto'
        end
        object Label9: TLabel
          Left = 6
          Top = 48
          Width = 56
          Height = 13
          Caption = 'Quantidade'
        end
        object Label10: TLabel
          Left = 230
          Top = 48
          Width = 64
          Height = 13
          Caption = 'Valor Unit'#225'rio'
        end
        object Label11: TLabel
          Left = 483
          Top = 48
          Width = 49
          Height = 13
          Caption = 'Total Item'
        end
        object btnPesquisaProduto: TButton
          Left = 634
          Top = 13
          Width = 21
          Height = 21
          Hint = 'Pesquisar Produto'
          ImageIndex = 0
          Images = ImageList
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          TabStop = False
          OnClick = btnPesquisaProdutoClick
        end
        object btnInserirItem: TButton
          Left = 187
          Top = 86
          Width = 120
          Height = 25
          Caption = 'Salvar Item'
          TabOrder = 6
          OnClick = btnInserirItemClick
        end
        object btnRemoverItem: TButton
          Left = 513
          Top = 86
          Width = 120
          Height = 25
          Caption = 'Remover Item'
          TabOrder = 7
          OnClick = btnRemoverItemClick
        end
        object VALOR_UNITARIO: TDBEdit
          Left = 296
          Top = 43
          Width = 121
          Height = 21
          DataField = 'VALOR_UNITARIO'
          DataSource = DataSource
          TabOrder = 4
        end
        object TOTAL_ITEM: TDBEdit
          Left = 534
          Top = 43
          Width = 121
          Height = 21
          TabStop = False
          DataField = 'TOTAL_ITEM'
          DataSource = DataSource
          Enabled = False
          ReadOnly = True
          TabOrder = 5
        end
        object QUANTIDADE: TDBEdit
          Left = 68
          Top = 43
          Width = 100
          Height = 21
          DataField = 'QUANTIDADE'
          DataSource = DataSource
          TabOrder = 1
        end
        object CODIGO_PRODUTO: TDBEdit
          Left = 68
          Top = 13
          Width = 100
          Height = 21
          DataField = 'CODIGO_PRODUTO'
          DataSource = DataSource
          TabOrder = 0
          OnKeyPress = CODIGO_PRODUTOKeyPress
        end
        object DESCRICAO: TDBEdit
          Left = 174
          Top = 13
          Width = 459
          Height = 21
          TabStop = False
          CharCase = ecUpperCase
          DataField = 'DESCRICAO'
          DataSource = DataSource
          Enabled = False
          ReadOnly = True
          TabOrder = 2
        end
        object btnNovoItem: TButton
          Left = 24
          Top = 86
          Width = 120
          Height = 25
          Caption = 'Novo Item'
          TabOrder = 8
          OnClick = btnNovoItemClick
        end
        object btnCancelarItem: TButton
          Left = 350
          Top = 86
          Width = 120
          Height = 25
          Caption = 'Cancelar Item'
          TabOrder = 9
          OnClick = btnCancelarItemClick
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 125
        Width = 670
        Height = 237
        Align = alClient
        TabOrder = 3
        object GridItensPedido: TDBGrid
          Left = 1
          Top = 1
          Width = 668
          Height = 235
          Align = alClient
          DataSource = DataSource
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgTitleHotTrack]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'CODIGO_PRODUTO'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESCRICAO'
              Title.Caption = 'Descri'#231#227'o'
              Width = 386
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'QUANTIDADE'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VALOR_UNITARIO'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TOTAL_ITEM'
              Visible = True
            end>
        end
      end
    end
  end
  object ImageList: TImageList
    Left = 352
    Top = 240
    Bitmap = {
      494C010101000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF333333003C3C3C00000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF2B2B
      2B000000000033333300000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FFB2B2B200414141000B0B0B001212120045454500A9A9A9002B2B2B000000
      00002B2B2B00000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF7A7A
      7A00000000002020200064646400646464001F1F1F0000000000000000002B2B
      2B00000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FFB2B2B2000000
      00005F5F5F00000000FF000000FF000000FF000000FF5E5E5E0000000000A9A9
      A900000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF404040002121
      2100000000FF000000FF000000FF000000FF000000FF000000FF202020004545
      4500000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF0B0B0B006565
      6500000000FF000000FF000000FF000000FF000000FF000000FF636363001313
      1300000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF0B0B0B006666
      6600000000FF000000FF000000FF000000FF000000FF000000FF646464000C0C
      0C00000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF3F3F3F002121
      2100000000FF000000FF000000FF000000FF000000FF000000FF202020004141
      4100000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FFB1B1B1000000
      000060606000000000FF000000FF000000FF000000FF5F5F5F0000000000B2B2
      B200000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF7878
      78000000000021212100656565006565650020202000000000007A7A7A000000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FFB1B1B1003F3F3F000A0A0A000A0A0A0040404000B2B2B200000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      FFF3000000000000FFE3000000000000F007000000000000E00F000000000000
      C78F000000000000CFCF000000000000CFCF000000000000CFCF000000000000
      CFCF000000000000C78F000000000000E01F000000000000F03F000000000000
      FFFF000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 456
    Top = 240
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterEdit = ClientDataSetAfterEdit
    Left = 536
    Top = 240
    object ClientDataSetCODIGO: TIntegerField
      FieldName = 'CODIGO'
    end
    object ClientDataSetDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 100
    end
    object ClientDataSetQUANTIDADE: TFloatField
      DisplayLabel = 'Quantidade'
      FieldName = 'QUANTIDADE'
      Required = True
      OnChange = ClientDataSetQUANTIDADEChange
    end
    object ClientDataSetVALOR_UNITARIO: TFloatField
      DisplayLabel = 'Valor Unit'#225'rio'
      FieldName = 'VALOR_UNITARIO'
      Required = True
      OnChange = ClientDataSetVALOR_UNITARIOChange
      currency = True
    end
    object ClientDataSetTOTAL_ITEM: TFloatField
      DisplayLabel = 'Total Item'
      FieldName = 'TOTAL_ITEM'
      currency = True
    end
    object ClientDataSetCODIGO_PEDIDO: TIntegerField
      FieldName = 'CODIGO_PEDIDO'
    end
    object ClientDataSetCODIGO_PRODUTO: TIntegerField
      DisplayLabel = 'Produto'
      FieldName = 'CODIGO_PRODUTO'
      Required = True
    end
  end
end
