pageextension 50103 NewFldsExt extends "Item Card"
{
    layout
    {
        addafter(Blocked)
        {
            field(BrandCode; BrandCode)
            {
                ApplicationArea = All;
            }
            field(CategoryCode; Category)
            {
                ApplicationArea = All;
            }
            field(ColorCode; Color)
            {
                ApplicationArea = All;
            }
            field(Size; Size)
            {
                ApplicationArea = All;
            }
            field(ProductName; ProductName)
            {
                ApplicationArea = All;
            }
            field(SuppStyleCode; SuppStyleCode)
            {
                ApplicationArea = All;
            }
            field(VendorID; VendorID)
            {
                ApplicationArea = All;
            }
            field(SupplierColor; SupplierColor)
            {
                ApplicationArea = All;
            }
            field(ProdGroup; ProdGroup)
            {
                ApplicationArea = All;
            }
            field(Created_at; Created_at)
            {
                ApplicationArea = All;
            }
            field(Config_Sku; Config_Sku)
            {
                ApplicationArea = All;
            }
            field(ItemCreatedDateTime; ItemCreatedDateTime)
            {
                ApplicationArea = All;
            }
            field("Last DateTime Modified"; "Last DateTime Modified")
            {
                ApplicationArea = All;
            }
            field(urlImgae; urlImgae)
            {
                ApplicationArea = All;
            }
            field(Concentration; "Item_type(Conc)")
            {
                ApplicationArea = All;
            }
            field(RetailPrice; RetailPrice)
            {
                ApplicationArea = All;
            }
            field(NewVendItemNo; NewVendItemNo)
            {
                ApplicationArea = All;
            }
            field("Return Inventory Posting Group"; "Return Inventory Posting Group")
            {
                ApplicationArea = All;
            }
            field("Return Prod Posting Group"; "Return Prod Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

    }
    procedure NewItemInit(itemSkc: code[20]);
    var
        ItemCard: Page "Item Card";
    begin
    end;
}
