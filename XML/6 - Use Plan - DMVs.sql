USE tempdb;
GO

CREATE TABLE #Tab1(ID1 INT)
CREATE TABLE #Tab2(ID2 INT)
GO

-- Consulta abaixo gera um HASH MATCH
SELECT * 
  FROM #Tab1
 INNER JOIN #Tab2
    ON #Tab1.ID1 = #Tab2.ID2
GO

-- Digamos que eu queira alterar a consulta para forcar um MERGE 
-- ao invéz de um HASH
SELECT * 
  FROM #Tab1
 INNER MERGE JOIN #Tab2
    ON #Tab1.ID1 = #Tab2.ID2

-- Após gerado o plano de execução desejado podemos salvar o plano para um 
-- arquivo XML e usar depois. Cliar com o botão direito no Excution Plan e
-- escolher Show Execution Plan as XML

-- Podemos copiar o plano gerado e forçar o SQL Server a sempre
-- utilizar o plano de execução gerado, este é apenas um exemplo,
-- você deve implementar o uso desta funcionalidade de acordo com sua regra
-- de negócio
SELECT *
  FROM #Tab1
 INNER JOIN #Tab2
    ON #Tab1.ID1 = #Tab2.ID2
OPTION (USE PLAN N'
<ShowPlanXML xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Version="1.1" Build="10.0.1442.32" xmlns="http://schemas.microsoft.com/sqlserver/2004/07/showplan">
  <BatchSequence>
    <Batch>
      <Statements>
        <StmtSimple StatementCompId="1" StatementEstRows="1" StatementId="1" StatementOptmLevel="FULL" StatementOptmEarlyAbortReason="GoodEnoughPlanFound" StatementSubTreeCost="0.0352521" StatementText="SELECT * &#xD;&#xA;  FROM #Tab1&#xD;&#xA; INNER MERGE JOIN #Tab2&#xD;&#xA;    ON #Tab1.ID1 = #Tab2.ID2" StatementType="SELECT" QueryHash="0x3522658D02A19256" QueryPlanHash="0xB52261EBA7F86985">
          <StatementSetOptions ANSI_NULLS="true" ANSI_PADDING="true" ANSI_WARNINGS="true" ARITHABORT="true" CONCAT_NULL_YIELDS_NULL="true" NUMERIC_ROUNDABORT="false" QUOTED_IDENTIFIER="true" />
          <QueryPlan CachedPlanSize="16" CompileTime="2" CompileCPU="2" CompileMemory="88">
            <RelOp AvgRowSize="15" EstimateCPU="0.00564738" EstimateIO="0.000313" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="1" LogicalOp="Inner Join" NodeId="0" Parallel="false" PhysicalOp="Merge Join" EstimatedTotalSubtreeCost="0.0352521">
              <OutputList>
                <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab1]" Column="ID1" />
                <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab2]" Column="ID2" />
              </OutputList>
              <Merge ManyToMany="true">
                <InnerSideJoinColumns>
                  <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab2]" Column="ID2" />
                </InnerSideJoinColumns>
                <OuterSideJoinColumns>
                  <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab1]" Column="ID1" />
                </OuterSideJoinColumns>
                <Residual>
                  <ScalarOperator ScalarString="[tempdb].[dbo].[#Tab2].[ID2]=[tempdb].[dbo].[#Tab1].[ID1]">
                    <Compare CompareOp="EQ">
                      <ScalarOperator>
                        <Identifier>
                          <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab2]" Column="ID2" />
                        </Identifier>
                      </ScalarOperator>
                      <ScalarOperator>
                        <Identifier>
                          <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab1]" Column="ID1" />
                        </Identifier>
                      </ScalarOperator>
                    </Compare>
                  </ScalarOperator>
                </Residual>
                <RelOp AvgRowSize="11" EstimateCPU="0.000100011" EstimateIO="0.0112613" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="1" LogicalOp="Sort" NodeId="1" Parallel="false" PhysicalOp="Sort" EstimatedTotalSubtreeCost="0.0146444">
                  <OutputList>
                    <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab1]" Column="ID1" />
                  </OutputList>
                  <MemoryFractions Input="1" Output="0.5" />
                  <Sort Distinct="false">
                    <OrderBy>
                      <OrderByColumn Ascending="true">
                        <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab1]" Column="ID1" />
                      </OrderByColumn>
                    </OrderBy>
                    <RelOp AvgRowSize="11" EstimateCPU="0.0001581" EstimateIO="0.003125" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="1" LogicalOp="Table Scan" NodeId="2" Parallel="false" PhysicalOp="Table Scan" EstimatedTotalSubtreeCost="0.0032831" TableCardinality="0">
                      <OutputList>
                        <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab1]" Column="ID1" />
                      </OutputList>
                      <TableScan Ordered="false" ForcedIndex="false" NoExpandHint="false">
                        <DefinedValues>
                          <DefinedValue>
                            <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab1]" Column="ID1" />
                          </DefinedValue>
                        </DefinedValues>
                        <Object Database="[tempdb]" Schema="[dbo]" Table="[#Tab1]" IndexKind="Heap" />
                      </TableScan>
                    </RelOp>
                  </Sort>
                </RelOp>
                <RelOp AvgRowSize="11" EstimateCPU="0.000100011" EstimateIO="0.0112613" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="1" LogicalOp="Sort" NodeId="3" Parallel="false" PhysicalOp="Sort" EstimatedTotalSubtreeCost="0.0146444">
                  <OutputList>
                    <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab2]" Column="ID2" />
                  </OutputList>
                  <MemoryFractions Input="0.5" Output="0.5" />
                  <Sort Distinct="false">
                    <OrderBy>
                      <OrderByColumn Ascending="true">
                        <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab2]" Column="ID2" />
                      </OrderByColumn>
                    </OrderBy>
                    <RelOp AvgRowSize="11" EstimateCPU="0.0001581" EstimateIO="0.003125" EstimateRebinds="0" EstimateRewinds="0" EstimateRows="1" LogicalOp="Table Scan" NodeId="4" Parallel="false" PhysicalOp="Table Scan" EstimatedTotalSubtreeCost="0.0032831" TableCardinality="0">
                      <OutputList>
                        <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab2]" Column="ID2" />
                      </OutputList>
                      <TableScan Ordered="false" ForcedIndex="false" NoExpandHint="false">
                        <DefinedValues>
                          <DefinedValue>
                            <ColumnReference Database="[tempdb]" Schema="[dbo]" Table="[#Tab2]" Column="ID2" />
                          </DefinedValue>
                        </DefinedValues>
                        <Object Database="[tempdb]" Schema="[dbo]" Table="[#Tab2]" IndexKind="Heap" />
                      </TableScan>
                    </RelOp>
                  </Sort>
                </RelOp>
              </Merge>
            </RelOp>
          </QueryPlan>
        </StmtSimple>
      </Statements>
    </Batch>
  </BatchSequence>
</ShowPlanXML>')



-- Agora veremos um exemplo de como consultar os planos de execução 
-- que estão no Cache do SQL Server

USE AdventureWorks
GO

SELECT QueryText.text,
       QueryPlan.query_plan,
       QueryStats.execution_count,
       QueryStats.total_elapsed_time,
       QueryStats.last_elapsed_time,
       QueryStats.total_logical_reads
  FROM sys.dm_exec_query_stats as QueryStats
 CROSS APPLY sys.dm_exec_sql_text(QueryStats.sql_handle) as QueryText
 CROSS APPLY sys.dm_exec_query_plan (QueryStats.plan_handle) as QueryPlan
 ORDER BY QueryStats.execution_count DESC

SELECT * 
  FROM Person.CountryRegion
 WHERE Name = 'Brazil'
GO 10