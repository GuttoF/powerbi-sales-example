let
    DataInicial = Date.StartOfYear(List.Min(fVendas[Data.Pedido])),
    DataFinal = Date.EndOfYear(List.Max(fVendas[Data.Pedido])),
    QtdeDias = Duration.Days(DataFinal - DataInicial) + 1,
    ListaDatas = List.Dates(DataInicial, QtdeDias, #duration(1,0,0,0)),
    #"Convertido para Tabela" = Table.FromList(ListaDatas, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Colunas Renomeadas" = Table.RenameColumns(#"Convertido para Tabela",{{"Column1", "Data.Pedido"}}),
    #"Ano Inserido" = Table.AddColumn(#"Colunas Renomeadas", "Ano", each Date.Year([Data.Pedido]), Int64.Type),
    #"Mês Inserido" = Table.AddColumn(#"Ano Inserido", "Mês", each Date.Month([Data.Pedido]), Int64.Type),
    #"Nome do Mês Inserido" = Table.AddColumn(#"Mês Inserido", "Nome do Mês", each Date.ToText([Data.Pedido], "MMMM", "pt-BR"), type text),
    #"Primeiros caracteres extraídos" = Table.TransformColumns(#"Nome do Mês Inserido", {{"Nome do Mês", each Text.Start(_, 3), type text}}),
    #"Trimestre Inserido" = Table.AddColumn(#"Primeiros caracteres extraídos", "Trimestre", each Date.QuarterOfYear([Data.Pedido]), Int64.Type),
    #"Semana do Ano Inserida" = Table.AddColumn(#"Trimestre Inserido", "Semana do Ano", each Date.WeekOfYear([Data.Pedido]), Int64.Type),
    #"Nome do Dia Inserido" = Table.AddColumn(#"Semana do Ano Inserida", "Nome do Dia", each Date.DayOfWeekName([Data.Pedido]), type text),
    #"Colocar Cada Palavra Em Maiúscula" = Table.AddColumn(#"Semana do Ano Inserida", "Nome do Dia", each Date.ToText([Data.Pedido], "dddd", "pt-BR"), type text),
    #"Colocar Cada Palavra Em Maiúscula1" = Table.TransformColumns(#"Colocar Cada Palavra Em Maiúscula",{{"Nome do Mês", Text.Proper, type text}, {"Nome do Dia", Text.Proper, type text}})
in
    #"Colocar Cada Palavra Em Maiúscula1"