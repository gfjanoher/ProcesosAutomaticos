codeunit 50600 "MBG Codeunit Control"
{
    Permissions = tabledata "Item Ledger Entry" = rimd, tabledata "Value Entry" = rimd;
    trigger OnRun()
    var
        CDU50306: Codeunit ProgramaTerceros;
        CDU50307: Codeunit ProgramaProyectos;
        // CDU50308 : Codeunit ProgramaProductosEnvio;
        CDU50365: Codeunit "MBG50365_Registrar Alta";
        CDU50366: Codeunit "MBG50366_Registrar Consumo";
        CDU50367: Codeunit "MBG50367_Registrar Ajuste";
        CDU50368: Codeunit "MBG50368_Registrar traslado";
        CDU50371: Codeunit "MBG50371_Registrar CONSUMO 2";
        CDU50372: Codeunit "MBG50372_Buscar ordenes lanz.";
        rsmov: record "Item Ledger Entry";
        rsmovse: record "Item Ledger Entry";
        rsmovne: record "Item Ledger Entry";
        valentry: Record "Value Entry";
    begin
        rsmov.SetFilter("Entry No.", '%1', 1434521);
        if rsmov.FindSet() then begin
            rsmov.Delete();

        end;
        valentry.SetFilter("Item Ledger Entry No.", '%1', 1434521);
        if valentry.FindSet() then begin
            repeat

                valentry.Delete();
            until valentry.Next() = 0;
        end;
        rsmov.Reset();
        rsmov.SetFilter("Entry No.", '%1', 1434191);
        if rsmov.FindSet() then begin
            rsmov."Shipped Qty. Not Returned" := 0;
            rsmov."Invoiced Quantity" := 0;
            rsmov.Modify()
        end;
        /*  CDU50306.Run;
          CDU50307.Run;
          //  CDU50308.Run;
          CDU50365.Run;
          CDU50366.Run;
          CDU50368.Run;
          CDU50371.Run;
          CDU50372.Run;*/



        //     CDU50367.Run;
    end;
}