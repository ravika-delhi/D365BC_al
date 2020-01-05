pageextension 50018 ExtendWhsItemJnLlines extends "Whse. Item Journal"
{
    layout
    {
    }
    actions
    {
        addafter("Bin Contents")
        {
            action("ImportFile")
            {
                Visible = false;
                ApplicationArea = Warehouse;
                Promoted = True;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    CustXmlFile: File;
                    lineText: Text;
                    whsJrnLine: Record "Warehouse Journal Line";
                    GSItemID: Code[20];
                    vendNo: code[20];
                    unitP: Decimal;
                    CSVBuffer: Record "CSV Buffer";
                    //TempBlob: Codeunit "Temp Blob";
                    UploadResult: Boolean;
                    DialogCaption: Text;
                    CSVFileName: Text;
                    StreamInTest: InStream;
                begin
                End;
            }
        }
    }
    var
        myInt: Integer;
}
