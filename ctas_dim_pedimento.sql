-- 1. Creamos la tabla física usando CTAS
CREATE TABLE dbo.Dim_Pedimento
WITH
(
    DISTRIBUTION = REPLICATE,
    CLUSTERED COLUMNSTORE INDEX
)
AS
-- 2. Primero, obtenemos los pedimentos únicos
WITH PedimentosUnicos AS (
    SELECT DISTINCT
        -- Casteamos a un tamaño razonable
        CAST(PEDIMENTOARMADO AS NVARCHAR(50)) AS PEDIMENTOARMADO
    FROM 
        dbo.stg_detallenp
    WHERE 
        PEDIMENTOARMADO IS NOT NULL
)
-- 3. Generamos el ID, y aplicamos el truco PARSENAME + REPLACE
SELECT 
    ROW_NUMBER() OVER(ORDER BY PEDIMENTOARMADO) AS Id_Pedimento,
    PEDIMENTOARMADO,
    
    -- PARSENAME lee de derecha a izquierda (3 es Aduana, 2 es Patente, 1 es Pedimento)
    CAST(PARSENAME(REPLACE(PEDIMENTOARMADO, '-', '.'), 3) AS NVARCHAR(10)) AS ADUANA,
    CAST(PARSENAME(REPLACE(PEDIMENTOARMADO, '-', '.'), 2) AS NVARCHAR(10)) AS PATENTE,
    CAST(PARSENAME(REPLACE(PEDIMENTOARMADO, '-', '.'), 1) AS NVARCHAR(20)) AS PEDIMENTO
FROM 
    PedimentosUnicos;