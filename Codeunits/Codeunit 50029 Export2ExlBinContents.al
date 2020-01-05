codeunit 50029 Export2ExcelBinContent
{
    trigger OnRun()
    begin
        Export2ExcelBinContents();
    end;

    procedure Export2ExcelBinContents()
    var
        TempExcelBuf: Record "Excel Buffer" temporary;
    begin
        FillExcelBufferBinContent(TempExcelBuf);
        OpenExcelFileBinC(TempExcelBuf);
    end;



    procedure Export2ExcelBinContent(binContent: Record "Bin Content")
    var
        TempExcelBuf: Record "Excel Buffer" temporary;
    begin
        FillExcelBufferBinContent1(TempExcelBuf, binContent);
        OpenExcelFileBinC(TempExcelBuf);
    end;


    procedure FillExcelBufferBinContent(var TempExcelBuf: Record "Excel Buffer")
    var
        binContent: Record "Bin Content";

    begin
        IF binContent.findset then begin
            MakeBinContentHeaders(TempExcelBuf, binContent);
            repeat
                FillExcelRowBinContent(TempExcelBuf, binContent);
            until binContent.next = 0;
        End;
    end;



    procedure FillExcelBufferBinContent1(var TempExcelBuf: Record "Excel Buffer";
       recBinContent: Record "Bin Content")
    var
        binContent: Record "Bin Content";

    begin
        binContent.reset;
        binContent.Setrange("Location Code", 'GS-DXB');

        IF binContent.findset then begin
            MakeBinContentHeaders(TempExcelBuf, binContent);
            repeat
                FillExcelRowBinContent(TempExcelBuf, binContent);
            until binContent.next = 0;
        end;
    end;


    procedure FillExcelRowBinContent(var TempExcelBuf: Record "Excel Buffer" temporary;
       binContent: Record "Bin Content")
    begin
        with binContent do begin
            binContent.CalcFields(binContent.Quantity, binContent."Pick Qty.", binContent."Put-away Qty.", binContent."Neg. Adjmt. Qty.", binContent."Pos. Adjmt. Qty.");
            AvailQty := binContent.CalcQtyAvailToTakeUOM;
            Items.get("Item No.");
            TempExcelBuf.NewRow();
            TempExcelBuf.AddColumn("Item No.", false, '', false, false, false, '', TempExcelBuf."Cell Type"::Text);
            TempExcelBuf.AddColumn("Bin Code", false, '', false, false, false, '', TempExcelBuf."Cell Type"::Number);
            TempExcelBuf.AddColumn("Bin Type Code", false, '', false, false, false, '', TempExcelBuf."Cell Type"::Text);
            TempExcelBuf.AddColumn(ProductName, false, '', false, false, false, '', TempExcelBuf."Cell Type"::Text);
            TempExcelBuf.AddColumn(Quantity, false, '', false, false, false, '', TempExcelBuf."Cell Type"::Number);
            TempExcelBuf.AddColumn("Pick Qty.", false, '', false, false, false, '', TempExcelBuf."Cell Type"::Number);
            TempExcelBuf.AddColumn("Put-away Qty.", false, '', false, false, false, '', TempExcelBuf."Cell Type"::Number);
            TempExcelBuf.AddColumn("Neg. Adjmt. Qty.", false, '', false, false, false, '', TempExcelBuf."Cell Type"::Number);
            TempExcelBuf.AddColumn("Pos. Adjmt. Qty.", false, '', false, false, false, '', TempExcelBuf."Cell Type"::Number);
            TempExcelBuf.AddColumn(AvailQty, false, '', false, false, false, '', TempExcelBuf."Cell Type"::Number);




        end;
    end;


    procedure OpenExcelFileBinC(var TempExcelBuf: Record "Excel Buffer" temporary)
    var
    begin
        TempExcelBuf.CreateNewBook('BinContents');
        TempExcelBuf.WriteSheet('BinContents', CompanyName(), UserId());
        TempExcelBuf.CloseBook();
        TempExcelBuf.OpenExcel();
    end;

    procedure MakeHeaders(var TempExcelBuf: Record "Excel Buffer" temporary;
    purchLine: Record "Purchase Line")
    var
    begin
        TempExcelBuf.AddColumn(purchLine.FieldCaption("Document No."), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("Line No."), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Number);

        TempExcelBuf.AddColumn(purchLine.FieldCaption("Buy-from Vendor No."), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption(VendorName), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("No."), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption(ProductName), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption(Quantity), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("Direct Unit Cost"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("Unit Cost"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("Line Amount"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("Line Discount %"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("Line Discount Amount"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("VAT %"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption(VAT_AMT), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("VAT Base Amount"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption("Web Order Id"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(purchLine.FieldCaption(GSOrderItemUID), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
    end;


    procedure MakeBinContentHeaders(var TempExcelBuf: Record "Excel Buffer" temporary;
    binContent: Record "Bin Content")
    var
    begin
        TempExcelBuf.AddColumn(binContent.FieldCaption("Item No."), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(binContent.FieldCaption("Bin Code"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);

        TempExcelBuf.AddColumn(binContent.FieldCaption("Bin Type Code"), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(binContent.FieldCaption(ProductName), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(binContent.FieldCaption(Quantity), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(binContent.FieldCaption("Pick Qty."), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(binContent.FieldCaption("Put-away Qty."), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(binContent.FieldCaption("Neg. Adjmt. Qty."), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn(binContent.FieldCaption("Pos. Adjmt. Qty."), FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);
        TempExcelBuf.AddColumn('AvailableQty', FALSE, '', TRUE, FALSE, TRUE, '', TempExcelBuf."Cell Type"::Text);

    end;


    var
        myInt: Integer;

    var
        Items: Record Item;
        Vend: Record vendor;
        AvailQty: Decimal;
}
