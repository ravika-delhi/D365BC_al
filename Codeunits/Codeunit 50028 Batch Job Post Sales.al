codeunit 50028 "Batch Job Post Sales"
{
    trigger OnRun()
    begin
        salesHdr.Reset;
        salesHdr.setrange("Document Type", salesHdr."Document Type"::Order);
        salesHdr.SetRange("Order Status", salesHdr."Order Status"::Shipped);
        IF salesHdr.FindFirst then
            repeat
                salesHdr.Invoice := True;
                salesHdr.Ship := True;

                SalesPost.Run(salesHdr)

            until salesHdr.Next = 0;

    end;

    var
        myInt: Integer;
        salesPostJob: Codeunit "Sales Post via Job Queue";
        SalesPost: codeunit "Sales-Post";
        salesHdr: Record "Sales Header";
        salesLine: Record "Sales Line";
}