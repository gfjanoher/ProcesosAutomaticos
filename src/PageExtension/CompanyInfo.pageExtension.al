pageextension 50600 "MBG 50600 Company Inf" extends "Company Information"
{
    layout
    {
        addafter("Control homologaciones prove.")
        {
            field("Usuario Tablas Intermedias"; REC."Usuario Tablas Intermedias")
            {
                ApplicationArea = All;
                ToolTip = 'Usuario Tablas Intermedias';
            }
        }
    }
}