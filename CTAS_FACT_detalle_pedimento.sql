-- 1. Creamos la tabla de Hechos física
CREATE TABLE dbo.Fact_DetalleOperaciones
WITH
(
    -- HASH distribuye los millones de filas equitativamente entre los nodos
    DISTRIBUTION = HASH(Id_Pedimento), 
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT 
    -- 2. Traemos las Llaves Foráneas (Sustituyendo los textos por números)
    dim_ped.Id_Pedimento,
    dim_prod.Id_Producto,
    
    -- 3. Traemos las Fechas (Las "casteamos" a tipo fecha real)
    CAST(stg.FECHA_FACTURA AS DATE) AS FECHA_FACTURA,
    CAST(stg.FECHAVALIDACION AS DATETIME2) AS FECHAVALIDACION,
    
    -- 4. Traemos los Hechos (Las métricas matemáticas que Power BI va a sumar)
    CAST(stg.CANTIDAD AS DECIMAL(18,4)) AS CANTIDAD,
    CAST(stg.PRECIO_TOTAL AS DECIMAL(18,4)) AS PRECIO_TOTAL,
    
    -- 5. Otras columnas operativas relevantes
    CAST(stg.SECUENCIA_PEDIMENTO AS INT) AS SECUENCIA_PEDIMENTO,
    CAST(stg.FME AS NVARCHAR(50)) AS FME,
    CAST(stg.FINC AS NVARCHAR(50)) AS FINC

FROM 
    dbo.stg_detallenp AS stg

-- 6. Hacemos los cruces para traducir el texto al ID numérico
LEFT JOIN dbo.Dim_Pedimento AS dim_ped
    ON stg.PEDIMENTOARMADO = dim_ped.PEDIMENTOARMADO
    
LEFT JOIN dbo.Dim_Producto AS dim_prod
    ON stg.CODIGO_PRODUCTO = dim_prod.CODIGO_PRODUCTO;