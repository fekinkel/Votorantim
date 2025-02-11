IF EXISTS (SELECT * FROM sys.types WHERE name = 'JSON') DROP TYPE dbo.JSON
CREATE TYPE dbo.JSON AS TABLE (
    Id_Elemento INT NOT NULL,
    Nr_Sequencia [INT] NULL,
    Id_Objeto_Pai INT,
    Id_Objeto INT,
    Ds_Nome NVARCHAR(2000),
    Ds_String NVARCHAR(MAX) NOT NULL,
    Ds_Tipo VARCHAR(10) NOT NULL,
    PRIMARY KEY (Id_Elemento)
)