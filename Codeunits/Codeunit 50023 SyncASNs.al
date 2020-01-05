codeunit 50023 "Sync-ASNs"
{
    trigger OnRun()
    begin

    end;


    procedure SyncSingleOrder(SalesRethdrs: Record "Sales Header")
    var
        SalesRetHdr1: Record "Sales Header";
        SalesRetLine1: Record "Sales Line";
        request: Text;
        request1: Text;
        url: Text;
        ResponseInStream: InStream;
        myint: Integer;
        httpClient: HttpClient;
        httpContent: HttpContent;
        httpHeaders: HttpHeaders;
        httpResponse: HttpResponseMessage;
        httpRequestMessage: HttpRequestMessage;
        AramexSetup: Record "GTFS Webservice Setup";
        Locset: Record Location;
        Purchaseetup: Record "Sales & Receivables Setup";
        paymentMethod: Record "Payment Method";
        amount: text[50];
        location: Record Location;
        AramexSetups: Record "GTFS Webservice Setup";
        WebServiceResponseMessage: HttpResponseMessage;
        WebServiceResponseText: Text;
        salesSetup: Record "Sales & Receivables Setup";

    begin
        salesSetup.Get;
        SalesRetHdr1.Reset;
        SalesRetHdr1.SetCurrentKey("Document Type", "No.");
        location.get(SalesRethdrs."Location Code");
        If location.WMSIntegration then Begin
            SRTransID := noSeriesMngmt.GetNextNo(location.AramexTransactionID, Today, true);
            AramexSetups.Get;

            SalesRetHdr1.SetRange("Document Type", SalesRethdrs."Document Type"::"Return Order");

            SalesRetHdr1.SetRange("No.", SalesRethdrs."No.");
            SalesRetHdr1.SetRange(Synced, False);
            SalesRetHdr1.SetRange("Location Code", SalesRethdrs."Location Code");
            SalesRetHdr1.SetRange("Aramex Reference No.", '');
            SalesRetHdr1.SetRange("Order Date", Today);

            IF SalesRetHdr1.FindFirst THEN begin

                request := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:corp="http://schemas.datacontract.org/2004/07/CORP.DXB.LOG.EDI_WS">';
                request += '<soapenv:Header/>';
                request += '<soapenv:Body>';
                request += '<tem:ImportASN>';
                request += '<tem:ASN>';
                request += '<corp:ApplicationHeader>';
                request += '<corp:RequestedDate></corp:RequestedDate>';
                request += '<corp:RequestedSystem></corp:RequestedSystem>';
                request += '<corp:TransactionID>' + SRTransID + '</corp:TransactionID>';
                request += '</corp:ApplicationHeader>';
                request += '<corp:DataHeader>';
                request += '<corp:ClinetSystemRef>' + SalesRetHdr1."No." + '</corp:ClinetSystemRef>';
                request += '<corp:Currency>' + SalesRetHdr1."Currency Code" + '</corp:Currency>';
                request += '<corp:Facility>' + location."Aramex Facility" + '</corp:Facility>';
                request += '<corp:StorerKey>' + location."Aramex StorerKey" + '</corp:StorerKey>';
                request += '</corp:DataHeader>';
                request += '<corp:DataLines>';
                SalesRetLine1.Reset;
                SalesRetLine1.SetRange("Document Type", SalesRetHdr1."Document Type");
                SalesRetLine1.SetRange("Document No.", SalesRetHdr1."No.");
                SalesRetLine1.SetRange(Type, SalesRetLine1.Type::Item);
                SalesRetLine1.SetRange(TransactionID, '');
                IF SalesRetLine1.FindFirst() THEN
                    repeat
                        request += '<corp:ARX_EDI._DataLine_ASN>';
                        request += '<corp:ExternLineNo>' + FORMAT(SalesRetLine1."Line No." / 10000) + '</corp:ExternLineNo>';
                        request += '<corp:LinePO>' + SalesRetLine1."Document No." + '</corp:LinePO>';
                        request += '<corp:Qty>' + Format(SalesRetLine1.Quantity) + '</corp:Qty>';
                        request += '<corp:SKU>' + SalesRetLine1."No." + '</corp:SKU>';
                        request += '<corp:UnitCost>9999.00</corp:UnitCost>';
                        request += '</corp:ARX_EDI._DataLine_ASN>';
                        SalesRetLine1."Order Status" := SalesRetLine1."Order Status"::Created;
                        SalesRetLine1.TransactionID := POTransID;
                        SalesRetLine1.Modify;
                    until SalesRetLine1.Next = 0;



                request += '</corp:DataLines>';
                request += '<corp:SSA>';
                request += '<corp:SSA_Login>' + AramexSetups."Aramex EDI Login Id" + '</corp:SSA_Login>';
                request += '<corp:SSA_Password>' + AramexSetups."Aramex EDI Password" + '</corp:SSA_Password>';
                request += '</corp:SSA>';
                request += '<corp:UserDate>';
                request += '<corp:ARX_EDI._UserDefineData></corp:ARX_EDI._UserDefineData>';
                request += '</corp:UserDate>';
                request += '</tem:ASN>';
                request += '</tem:ImportASN>';
                request += '</soapenv:Body>';
                request += '</soapenv:Envelope>';


            End;
            url := Purchaseetup."WhsIntegration API/URL";


            httpContent.GetHeaders(httpHeaders);



            Message(request);
            httpContent.WriteFrom(request);

            httpContent.GetHeaders(httpHeaders);
            httpHeaders.Remove('SOAPAction');
            httpHeaders.Remove('Content-type');
            httpHeaders.Add('Content-type', 'text/xml');
            httpHeaders.Add('SOAPAction', 'http://tempuri.org/IService_EDI/ImportASN');
            //httpHeaders.TryAddWithoutValidation('Action', '*/*');
            httpHeaders.TryAddWithoutValidation('POST', '/WS_EDI_V02/Service_EDI.svc HTTP/1.1');
            httpHeaders.TryAddWithoutValidation('Host', 'portal.infor.aramex.com');
            httpHeaders.TryAddWithoutValidation('Cache-Control', 'no-cache');
            //httpHeaders.TryAddWithoutValidation('accept-encoding', 'gzip, deflate');
            //httpHeaders.TryAddWithoutValidation('Connection', 'keep-alive');
            //httpRequestMessage.GetHeaders(httpHeaders);

            httpRequestMessage.Content := httpContent;
            if httpClient.Post(url, httpContent, httpResponse) then begin
                httpResponse.Content.ReadAs(WebServiceResponseText);
                ProcessXMLResponse(WebServiceResponseText, SalesRetHdr1);
                MESSAGE(httpResponse.ReasonPhrase);
            End Else
                MESSAGE(httpResponse.ReasonPhrase);
            // Message('Error');
        end;
    end;

    procedure SyncPurchaseASN(Purchasehdrs: Record "Purchase Header")
    var
        PurchaseHdr1: Record "Purchase Header";
        PurchaseLine1: Record "Purchase Line";
        request: Text;
        request1: Text;
        url: Text;
        ResponseInStream: InStream;
        myint: Integer;
        httpClient: HttpClient;
        httpContent: HttpContent;
        httpHeaders: HttpHeaders;
        httpResponse: HttpResponseMessage;
        httpRequestMessage: HttpRequestMessage;
        AramexSetup: Record "GTFS Webservice Setup";
        Locset: Record Location;
        Purchaseetup: Record "Sales & Receivables Setup";
        paymentMethod: Record "Payment Method";
        amount: text[50];
        location: Record Location;
        AramexSetups: Record "GTFS Webservice Setup";
        WebServiceResponseMessage: HttpResponseMessage;
        WebServiceResponseText: Text;
        salesSetup: Record "Sales & Receivables Setup";
    begin
        salessetup.Get;
        PurchaseHdr1.Reset;
        PurchaseHdr1.SetCurrentKey("Document Type", "No.");
        location.get(Purchasehdrs."Location Code");
        POTransID := noSeriesMngmt.GetNextNo(location.AramexTransactionID, Today, true);
        AramexSetups.Get;
        IF location.WMSIntegration Then BEGIN
            PurchaseHdr1.SetRange("Document Type", Purchasehdrs."Document Type"::Order);
            PurchaseHdr1.SetRange(Synced, False);
            PurchaseHdr1.SetRange("Location Code", Purchasehdrs."Location Code");
            PurchaseHdr1.SetRange("Aramex Reference No.", '');

            IF PurchaseHdr1.FindFirst THEN begin

                request := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:corp="http://schemas.datacontract.org/2004/07/CORP.DXB.LOG.EDI_WS">';
                request += '<soapenv:Header/>';
                request += '<soapenv:Body>';
                request += '<tem:ImportASN>';
                request += '<tem:ASN>';
                request += '<corp:ApplicationHeader>';
                request += '<corp:RequestedDate></corp:RequestedDate>';
                request += '<corp:RequestedSystem></corp:RequestedSystem>';
                request += '<corp:TransactionID>' + POTransID + '</corp:TransactionID>';
                request += '</corp:ApplicationHeader>';
                request += '<corp:DataHeader>';
                request += '<corp:ClinetSystemRef>' + PurchaseHdr1."No." + '</corp:ClinetSystemRef>';
                request += '<corp:Currency>' + PurchaseHdr1."Currency Code" + '</corp:Currency>';
                request += '<corp:Facility>' + location."Aramex Facility" + '</corp:Facility>';
                request += '<corp:StorerKey>' + location."Aramex StorerKey" + '</corp:StorerKey>';
                request += '</corp:DataHeader>';
                request += '<corp:DataLines>';
                PurchaseLine1.Reset;
                PurchaseLine1.SetRange("Document Type", PurchaseHdr1."Document Type");
                PurchaseLine1.SetRange("Document No.", PurchaseHdr1."No.");
                PurchaseLine1.SetRange(Type, PurchaseLine1.Type::Item);
                IF PurchaseLine1.FindFirst() THEN
                    repeat
                        request += '<corp:ARX_EDI._DataLine_ASN>';
                        request += '<corp:ExternLineNo>' + FORMAT(PurchaseLine1."Line No." / 10000) + '</corp:ExternLineNo>';
                        request += '<corp:LinePO>' + PurchaseLine1."Document No." + '</corp:LinePO>';
                        request += '<corp:Qty>' + Format(PurchaseLine1.Quantity) + '</corp:Qty>';
                        request += '<corp:SKU>' + PurchaseLine1."No." + '</corp:SKU>';
                        request += '<corp:UnitCost>9999.00</corp:UnitPrice>';
                        request += '</corp:ARX_EDI._DataLine_ASN>';
                        PurchaseLine1."Order Status" := PurchaseLine1."Order Status"::Created;
                        PurchaseLine1.TransactionID := POTransID;
                        PurchaseLine1.Modify;
                    until PurchaseLine1.Next = 0;



                request += '</corp:DataLines>';
                request += '<corp:SSA>';
                request += '<corp:SSA_Login>' + AramexSetups."Aramex EDI Login Id" + '</corp:SSA_Login>';
                request += '<corp:SSA_Password>' + AramexSetups."Aramex EDI Password" + '</corp:SSA_Password>';
                request += '</corp:SSA>';
                request += '<corp:UserDate>';
                request += '<corp:ARX_EDI._UserDefineData></corp:ARX_EDI._UserDefineData>';
                request += '</corp:UserDate>';
                request += '</tem:ASN>';
                request += '</tem:ImportASN>';
                request += '</soapenv:Body>';
                request += '</soapenv:Envelope>';


            End;
            url := Purchaseetup."WhsIntegration API/URL";


            httpContent.GetHeaders(httpHeaders);



            Message(request);
            httpContent.WriteFrom(request);

            httpContent.GetHeaders(httpHeaders);
            httpHeaders.Remove('SOAPAction');
            httpHeaders.Remove('Content-type');
            httpHeaders.Add('Content-type', 'text/xml');
            httpHeaders.Add('SOAPAction', 'http://tempuri.org/IService_EDI/ImportASN');
            //httpHeaders.TryAddWithoutValidation('Action', '*/*');
            httpHeaders.TryAddWithoutValidation('POST', '/WS_EDI_V02/Service_EDI.svc HTTP/1.1');
            httpHeaders.TryAddWithoutValidation('Host', 'portal.infor.aramex.com');
            httpHeaders.TryAddWithoutValidation('Cache-Control', 'no-cache');
            //httpHeaders.TryAddWithoutValidation('accept-encoding', 'gzip, deflate');
            //httpHeaders.TryAddWithoutValidation('Connection', 'keep-alive');
            //httpRequestMessage.GetHeaders(httpHeaders);

            httpRequestMessage.Content := httpContent;
            if httpClient.Post(url, httpContent, httpResponse) then begin
                httpResponse.Content.ReadAs(WebServiceResponseText);
                ProcessXMLResponseASN(WebServiceResponseText, PurchaseHdr1);
                MESSAGE(httpResponse.ReasonPhrase);
            End Else
                MESSAGE(httpResponse.ReasonPhrase);
            // Message('Error');
        END;
    end;

    procedure ProcessXMLResponse(ResponseTxt: Text;
        SalesHeader: Record "Sales Header")
    var
        ErrorDescTxt: Text;
        ErrorCodeTxt: Text;
        ErrorTxt: Label 'Error Code: %1.\%2';
    begin
        if strpos(ResponseTxt, '<a:Status>') <> 0 then begin
            if GetXMLTagvalue(ResponseTxt, '<a:Status>', '</a:Status>') = 'SUCCESS' then begin
                SalesHeader."Aramex Reference No." := GetXMLTagvalue(ResponseTxt, '<a:Reference>', '</a:Reference>');
                SalesHeader."Order Status" := SalesHeader."Order Status"::Processing3PL;
                SalesHeader.Modify();
            end
            else begin
                ErrorCodeTxt := GetXMLTagvalue(ResponseTxt, '<a:ErrorCode>', '</a:ErrorCode>');
                ErrorDescTxt := GetXMLTagvalue(ResponseTxt, '<a:ErrorDescription>', '</a:ErrorDescription>');
                Error(ErrorTxt, ErrorCodeTxt, ErrorDescTxt);
            end;
        end;
    end;

    procedure GetXMLTagvalue(SourceText: Text;
    StartTag: Text;
    EndTag: Text): Text
    begin
        exit(CopyStr(SourceText, strpos(SourceText, StartTag) + StrLen(StartTag), strpos(SourceText, EndTag) - (strpos(SourceText, StartTag) + StrLen(StartTag))));
    end;

    procedure ProcessXMLResponseASN(ResponseTxt: Text;
        purchaseHeader: Record "Purchase Header")
    var
        ErrorDescTxt: Text;
        ErrorCodeTxt: Text;
        ErrorTxt: Label 'Error Code: %1.\%2';
    begin
        if strpos(ResponseTxt, '<a:Status>') <> 0 then begin
            if GetXMLTagvalue(ResponseTxt, '<a:Status>', '</a:Status>') = 'SUCCESS' then begin
                purchaseHeader."Aramex Reference No." := GetXMLTagvalue(ResponseTxt, '<a:Reference>', '</a:Reference>');
                purchaseHeader.Modify();
            end
            else begin
                ErrorCodeTxt := GetXMLTagvalue(ResponseTxt, '<a:ErrorCode>', '</a:ErrorCode>');
                ErrorDescTxt := GetXMLTagvalue(ResponseTxt, '<a:ErrorDescription>', '</a:ErrorDescription>');
                Error(ErrorTxt, ErrorCodeTxt, ErrorDescTxt);
            end;
        end;
    end;

    var
        myInt: Integer;
        PurchaseHdr: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        OrderTrack: Record "Order Tracking Table";
        noSeriesMngmt: Codeunit NoSeriesManagement;
        SRTransID: Text[100];
        POTransID: Text[100];

}