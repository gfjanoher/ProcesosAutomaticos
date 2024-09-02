//Created by GFJ 27/01/2022 automatismo para el control de las colas
codeunit 50601 MBG50601ControlTablasInter
{

    trigger OnRun()
    var
        rsAuto: record "MBS50352_Log BC A WCS";
        rsStock: Record "MBS50355_Ajuste de stocks";
        rsBloqueoStock: Record "MBS50359_Bloqueo de stock";
        rsConsulta: Record "MBS50360_Consulta de stock";
        rsInvent: record "MBS50357_Invent. de stock Hdr.";
        rsAltaProd: record "MBS50351_Alta Producto acabado";
        rsTraslados: Record MBS50356_TrasladosAlmacenes;
        rsStockAlm: Record "MBG50361_Consul. de stock alm.";
        rsConsumo: record "MBS50352_Consumo de Comp. Hdr.";
        datet: DateTime;
        datenormal: date;
        ttime: Time;
        sendMail: Boolean;
    begin
        // if checkInstance() = true then begin
        ttime := Time();
        datenormal := CalcDate('-5D', Today);
        //     pasar datenormal a la variable datet
        datet := CreateDateTime(datenormal, ttime);
        messageError := 'Se ha dado al menos un error en los siguientes procesos:';
        sendMail := false;
        position := 1;
        rsTraslados.SetRange("Fecha/Hora recibido", datet, CurrentDateTime);
        // rsAuto.Setfilter("Codigo Error", '<>%', '');
        rsTraslados.SetRange(Notificado, false);
        if rsTraslados.FindSet() then begin
            repeat
                if rsTraslados.Error <> '' then begin
                    rsTraslados.Notificado := true;
                    rsTraslados.Modify();
                    setArray(rsauto."Codigo Error", 'Traslado entre almacenes - ' + rsTraslados.Error, position);
                    position := position + 1;
                    sendMail := true;
                end;
            until rsAuto.Next() = 0;
        end;
        rsBloqueoStock.SetRange("Fecha/Hora recibido", datet, CurrentDateTime);

        rsBloqueoStock.SetRange(Notificado, false);
        if rsBloqueoStock.FindSet() then begin
            repeat
                if rsBloqueoStock."Error" <> '' then begin
                    rsBloqueoStock.Notificado := true;
                    rsBloqueoStock.Modify();
                    setArray(rsBloqueoStock.Error, 'Bloqueo de stock', position);
                    position := position + 1;
                    sendMail := true;
                end;
            until rsBloqueoStock.Next() = 0;
        end;
        rsBloqueoStock.SetRange("Fecha/Hora recibido", datet, CurrentDateTime);

        rsBloqueoStock.SetRange(Notificado, false);
        if rsBloqueoStock.FindSet() then begin
            repeat
                if rsBloqueoStock."Error" <> '' then begin
                    rsBloqueoStock.Notificado := true;
                    rsBloqueoStock.Modify();
                    setArray(rsBloqueoStock.Error, 'Bloqueo de stock', position);
                    position := position + 1;
                    sendMail := true;
                end;
            until rsBloqueoStock.Next() = 0;
        end;
        rsInvent.SetRange("Fecha/Hora recibido", datet, CurrentDateTime);

        rsInvent.SetRange(Notificado, false);
        if rsInvent.FindSet() then begin
            repeat
                if rsInvent."Error" <> '' then begin
                    rsInvent.Notificado := true;
                    rsInvent.Modify();
                    setArray(rsInvent.Error, 'Inventario de stocks', position);
                    position := position + 1;
                    sendMail := true;
                end;
            until rsInvent.Next() = 0;
        end;
        rsStock.SetRange("Fecha/Hora recibido", datet, CurrentDateTime);

        rsStock.SetRange(Notificado, false);
        if rsStock.FindSet() then begin
            repeat
                if rsStock."Error" <> '' then begin
                    rsStock.Notificado := true;
                    rsStock.Modify();
                    setArray(rsStock.adjustmentReasonDesc, 'Ajuste de stocks', position);
                    position := position + 1;
                    sendMail := true;
                end;
            until rsStock.Next() = 0;
        end;
        rsStockAlm.SetRange("Fecha/Hora recibido", datet, CurrentDateTime);

        rsStockAlm.SetRange(Notificado, false);
        if rsStockAlm.FindSet() then begin
            repeat
                if rsStockAlm."Error" <> '' then begin
                    rsStockAlm.Notificado := true;
                    rsStockAlm.Modify();
                    setArray(rsStockAlm.warehouseId, 'Consulta sotck por almacén', position);
                    position := position + 1;
                    sendMail := true;
                end;
            until rsStockAlm.Next() = 0;
        end;

        rsConsulta.SetRange("Fecha/Hora recibido", datet, CurrentDateTime);

        rsConsulta.SetRange(Notificado, false);
        if rsConsulta.FindSet() then begin
            repeat
                if rsConsulta."Error" <> '' then begin
                    rsConsulta.Notificado := true;
                    rsConsulta.Modify();
                    setArray(rsConsulta.materialId, 'Consulta de stock', position);
                    position := position + 1;
                    sendMail := true;
                end;
            until rsConsulta.Next() = 0;
        end;
        rsConsumo.SetRange("Fecha/Hora recibido", datet, CurrentDateTime);

        rsConsumo.SetRange(Notificado, false);
        if rsConsumo.FindSet() then begin
            repeat
                if rsConsumo."Error" <> '' then begin
                    rsConsumo.Notificado := true;
                    rsConsumo.Modify();
                    setArray(rsConsumo.Error, 'Consumo de componentes', position);
                    position := position + 1;
                    sendMail := true;
                end;
            until rsConsumo.Next() = 0;
        end;
        rsAltaProd.SetRange("Fecha/Hora recibido", datet, CurrentDateTime);

        rsAltaProd.SetRange(Notificado, false);
        if rsAltaProd.FindSet() then begin
            repeat
                if rsAltaProd."Error" <> '' then begin
                    rsAltaProd.Notificado := true;
                    rsAltaProd.Modify();
                    setArray(rsAltaProd.Error, 'Alta Producto Terminado', position);
                    position := position + 1;
                    sendMail := true;
                end;
            until rsAltaProd.Next() = 0;
        end;

        if sendMail then createMail();
        //  end;
    end;

    local procedure setArray(numID: Code[20]; nameID: Text; position: Integer)
    var
    begin

        ArrayText[position] [1] := format(numID) + '-' + nameID;

    end;



    local procedure createMail()
    var
        l_asuntoEmail: Text;
        l_emailTo: List of [Text];
        lenArray: Integer;
        i: Integer;
        stringMessage: Text;
        space: text;
        space_tittle: text;
        htmldocument: Text;
        CompanyInfo: Record "Company Information";
        ImageToBase64: Text;
        In_Stream: InStream;
        cduBase64Convert: Codeunit "Base64 Convert";
        numCap: Decimal;
        numQty: Decimal;
        timeStandard: time;
        timeDesviated: time;
        bodyText: TEXT;
        locRecCompInfo: Record "Company Information";
    begin
        space := '                              ';
        space_tittle := ' ';
        emailResource := emailResource;
        Clear(l_emailTo);
        locRecCompInfo.Get();
        if locRecCompInfo."Usuario Tablas Intermedias" <> '' then begin
            l_emailTo.Add(locRecCompInfo."Usuario Tablas Intermedias");

            l_asuntoEmail := 'Errores en tablas intermedias.';

            CompanyInfo.Get();

            bodyText := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional //EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
            bodyText := bodyText + '<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />';
            bodyText := bodyText + '<meta name="viewport" content="width=device-width, initial-scale=1.0"/></head><body style="margin: 0; padding: 0;">';
            bodyText := bodyText + '<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td style="padding: 10px 0 30px 0;">';
            bodyText := bodyText + '<table align="center" border="0" cellpadding="0" cellspacing="0" width="800" style="border: 1px solid #cccccc; border-collapse: collapse;">';
            bodyText := bodyText + '<tr>';
            bodyText := bodyText + '<td>';
            bodyText := bodyText + '<img src="data:image/png;base64,' + ImageToBase64 + '" height="130" width="100%" alt="RVT" >';
            bodyText := bodyText + '</td>';
            bodyText := bodyText + '</tr>';
            bodyText := bodyText + '<tr>';
            bodyText := bodyText + '<td bgcolor="#ffffff" style="padding: 40px 30px 40px 30px;">';
            bodyText := bodyText + '<table border="0" cellpadding="0" cellspacing="0" width="100%">';
            bodyText := bodyText + '<tr>';
            bodyText := bodyText + '<div>';
            bodyText := bodyText + '<td style="color: #1393C5; font-family: Calibri, sans-serif; font-size: 24px; text-align:  center;"><b>Control tablas intermedias</b>';
            bodyText := bodyText + '<div style="background: #1393C5; font-size: 1px; line-height: 1px;">&nbsp;</div>';
            bodyText := bodyText + '</td>';
            bodyText := bodyText + '</div>';
            bodyText := bodyText + '</tr>';
            bodyText := bodyText + '<tr>';
            bodyText := bodyText + '<td style="padding: 20px 0px 0px 0; color: #000000; font-family: Calibri, sans-serif; font-size: 24px; line-height: 20px;">';
            bodyText := bodyText + '<div style="padding: 10px 0px 0px 0; color: #000000; font-family: Calibri, sans-serif; font-size: 24px; line-height: 20px;">';
            bodyText := bodyText + '<div style="color: #000000; font-family: Calibri, sans-serif; font-size: 14px; line-height: 20px;" >Hola' + space_tittle + ',</div>';
            bodyText := bodyText + '<p style="color: #000000; font-family: Calibri, sans-serif; font-size: 14px; line-height: 20px;">Al menos un error detectado.</p>';
            bodyText := bodyText + '</div>';
            bodyText := bodyText + '</td>';
            bodyText := bodyText + '</tr>';
            bodyText := bodyText + '<tr>';
            bodyText := bodyText + '<td>';
            bodyText := bodyText + '<table cellpadding="0" cellspacing="0" width="100%"><tr rowspan="2" valign="middle" align="left">';
            bodyText := bodyText + '</td></tr>';
            bodyText := bodyText + '<tr style="padding: 0px 0 0px 0; color: #000000; font-family: Calibri, sans-serif; font-size: 14px; line-height: px;">';
            bodyText := bodyText + '<ul style="color: #000000; font-family: Calibri, sans-serif; font-size: 14px; line-height: 20px;">';
            i := 1;
            stringMessage := '';
            repeat
                if ArrayText[i] [1] <> '' then begin
                    bodyText := bodyText + '<li> Proceso   <b>' + ArrayText[i] [1] + '</b></li>';
                end;
                i += 1;
            until i > 31;
            bodyText := bodyText + '</ul>';
            bodyText := bodyText + '<td style="padding: 20px 0 30px 0; color: #000000; font-family: Calibri, sans-serif; font-size: 14px; line-height: 20px;">';
            bodyText := bodyText + '<div style="padding: 10px 0 0px 0; color: #000000; font-family: Calibri, sans-serif; font-size: 14px; line-height: 20px;">';
            bodyText := bodyText + ' <p style="color: #000000; font-family: Calibri, sans-serif; font-size: 14px; line-height: 20px;"> Revisa los errores.</p>';
            bodyText := bodyText + '<br><div style="color: #000000; font-family: Calibri, sans-serif; font-size: 14px; line-height: 20px;">Saludos</div>';
            bodyText := bodyText + '</div> </td>';
            bodyText := bodyText + '</tr></table></td></tr></table></td></tr></table></td></tr></table></body></html>';

            EmailMessage.Create(l_emailTo, l_asuntoEmail, bodyText, true);
            if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
                Error(GetLastErrorText());
            end;
            // end;
        end;
    end;

    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        emailResource: Text;
        userId: text;

        DateInit: Date;
        DateFinish: date;
        position: Integer;
        messageError: Text;
        ArrayText: Array[50, 2] of Text[80];
}