pageextension 50004 ExtBinContent extends "Bin Content"
{
    layout
    {
        addafter("Item No.")
        {
            field(ProductName; ProductName)
            {
                ApplicationArea = all;
                Visible = true;
            }
            field(InventoryType; InventoryType)
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
    }

    actions
    {
        addfirst(Navigation)
        {
            action(Export2Excel)
            {
                Caption = 'Export to Excel';
                ApplicationArea = All;
                Image = Excel;

                trigger OnAction()
                var
                    BinContent: Record "Bin Content";
                    exp2xl: Codeunit Export2ExcelBinContent;
                begin
                    BinContent.reset;
                    BinContent.SetRange("Location Code", 'GS-DXB');

                    IF BinContent.Findfirst then
                        exp2xl.Export2ExcelBinContent(BinContent);
                    //Codeunit.Run(codeunit::Export2Excel);
                end;
            }
        }

    }




    var
        myInt: Integer;
}