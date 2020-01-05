codeunit 50006 "Sync-SalesOrdersJDH"
{
    trigger OnRun()
    begin

    end;

    procedure SyncNewOrders()
    var
        salesHdr1: Record "Sales Header";
        salesLine1: Record "Sales Line";
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
        saleSetup: Record "Sales & Receivables Setup";
    begin
        saleSetup.Get;
        salesHdr1.Reset;
        salesHdr1.SetCurrentKey("Document Type", "No.");

        salesHdr1.SetRange("Document Type", salesHdr1."Document Type"::Order);
        salesHdr1.SetRange(Synced, False);
        salesHdr1.SetRange("Location Code", saleSetup."Default Location Code");
        IF salesHdr1.FindFirst THEN begin
            request := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:corp="http://schemas.datacontract.org/2004/07/CORP.DXB.LOG.EDI_WS">';
            request += '<soapenv:Header/>';
            request += '<soapenv:Body>';
            request += ' <tem:ImportSO>';
            request += '<tem:SO>';
            request += '   <corp:ApplicationHeader>';
            request += '<corp:RequestedDate></corp:RequestedDate>';
            request += '<corp:RequestedSystem></corp:RequestedSystem>';
            request += ' <corp:TransactionID>0001</corp:TransactionID>';
            request += '</corp:ApplicationHeader>';
            request += '<corp:DataHeader>';
            request += '<corp:B_Address>';
            request += '<corp:Address1>' + salesHdr1."Sell-to Customer Name" + '</corp:Address1>';
            request += '<corp:Address2>' + salesHdr1."Sell-to Address" + '</corp:Address2>';
            request += '<corp:Address3>' + salesHdr1."Sell-to Country/Region Code" + '</corp:Address3>';
            request += '<corp:City>' + salesHdr1."Sell-to City" + '</corp:City>';
            request += '<corp:Company>' + salesHdr1."Sell-to Customer Name" + '</corp:Company>';
            request += '<corp:Contact>' + salesHdr1."Sell-to Phone No." + '</corp:Contact>';
            request += '<corp:Country>' + salesHdr1."Sell-to Country/Region Code" + '</corp:Country>';
            request += '<corp:Email>' + salesHdr1."Sell-to E-Mail" + '</corp:Email>';
            request += '<corp:Fax>' + salesHdr1."Sell-to Phone No." + '</corp:Fax>';
            request += '<corp:Phone1>' + salesHdr1."Sell-to Phone No." + '</corp:Phone1>';
            request += '<corp:Phone2>' + salesHdr1."Sell-to Phone No." + '</corp:Phone2>';
            request += '      <corp:Ref>' + salesHdr1."No." + '</corp:Ref>';
            request += '<corp:State></corp:State>';
            request += '<corp:ZipCode></corp:ZipCode>';
            request += '</corp:B_Address>';
            request += '<corp:CTSService>' + salesHdr1."Payment Method Code" + '</corp:CTSService>';
            request += '<corp:CTSValue>0</corp:CTSValue>';
            request += '<corp:C_Address>';
            request += '<corp:Address1>' + salesHdr1."Ship-to Name" + '</corp:Address1>';
            request += ' <corp:Address2>' + salesHdr1."Ship-to Address" + '</corp:Address2>';
            request += '<corp:Address3>' + salesHdr1."Ship-to Address 2" + '</corp:Address3>';
            request += '<corp:City>' + salesHdr1."Ship-to City" + '</corp:City>';
            request += '< corp:Company>' + salesHdr1."Ship-to Name" + '</corp:Company>';
            request += '<corp:Contact>' + salesHdr1."Ship-to Name" + '</corp:Contact>';
            request += '<corp:Country>' + salesHdr1."Ship-to Country/Region Code" + '</corp:Country>';
            request += '<corp:Email>' + salesHdr1."Ship-to E-Mail" + '</corp:Email>';
            request += '<corp:Fax></corp:Fax>';
            request += '<corp:Phone1>' + salesHdr1."Ship-to Phone No." + '</corp:Phone1>';
            request += '<corp:Phone2>' + salesHdr1."Ship-to Phone No." + '</corp:Phone2>';
            request += '<corp:Ref>' + salesHdr1."No." + '</corp:Ref>';
            request += '<corp:State></corp:State>';
            request += '<corp:ZipCode></corp:ZipCode>';
            request += '</corp:C_Address>';
            request += '<corp:ClinetSystemRef>' + salesHdr1."No." + '</corp:ClinetSystemRef>';
            request += '<corp:Currency>' + salesHdr1."Currency Code" + '</corp:Currency>';
            request += '<corp:D_Address>';
            request += ' <corp:Address1>' + salesHdr1."Ship-to Name" + '</corp:Address1>';
            request += '<corp:Address2>' + salesHdr1."Bill-to Address" + '</corp:Address2>';
            request += '<corp:Address3>' + salesHdr1."Bill-to Address 2" + '</corp:Address3>';
            request += '<corp:City>' + salesHdr1."Ship-to City" + '</corp:City>';
            request += '< corp:Company>' + salesHdr1."Ship-to Name" + '</corp:Company>';
            request += '      <corp:Contact>' + salesHdr1."Sell-to Contact" + '</corp:Contact>';
            request += '      <corp:Country>' + salesHdr1."Ship-to Country/Region Code" + '</corp:Country>';
            request += '<corp:Email>' + salesHdr1."Ship-to E-Mail" + '</corp:Email>';
            request += '<corp:Fax>' + salesHdr1."Ship-to Phone No." + '</corp:Fax>';
            request += '<corp:Phone1>' + salesHdr1."Ship-to Phone No." + '</corp:Phone1>';
            request += '<corp:Phone2>' + salesHdr1."Ship-to Phone No." + '</corp:Phone2>';
            request += ' <corp:Ref></corp:Ref>';
            request += '<corp:State></corp:State>';
            request += '<corp:ZipCode></corp:ZipCode>';
            request += '</corp:D_Address>';
            request += '<corp:Facility>WMWHSE1</corp:Facility>';
            request += '<corp:Forwarder>aramex</corp:Forwarder>';
            request += '<corp:StorerKey>GC</corp:StorerKey>';
            request += '<corp:TransportationMode>Express</corp:TransportationMode>';
            request += '</corp:DataHeader>';
            request += '<corp:DataLines>';
            salesLine1.Reset;
            salesLine1.SetRange("Document Type", salesHdr1."Document Type");
            salesLine1.SetRange("Document No.", salesHdr1."No.");
            salesLine1.Setfilter("Order Status", '<>%1', salesLine1."Order Status"::Created);
            IF salesLine1.FindFirst() THEN
                repeat
                    request += '<corp:ARX_EDI._DataLine_SO>';
                    request += '<corp:ExternLineNo>' + FORMAT(SalesLine1."Line No.") + '</corp:ExternLineNo>';
                    request += '<corp:Qty>' + Format(salesLine1.Quantity) + '</corp:Qty>';
                    request += '<corp:SKU>' + salesLine1."No." + '</corp:SKU>';
                    request += '<corp:UnitPrice>' + Format(SalesLine1."Unit Price") + '</corp:UnitPrice>';
                    request += '</corp:ARX_EDI._DataLine_SO>';
                    salesLine1."Order Status" := salesLine1."Order Status"::Created;
                    salesLine1.Modify;
                until salesLine1.Next = 0;



            request += '</corp:DataLines>';
            request += '<corp:SSA>';
            request += ' <corp:SSA_Login>wptest</corp:SSA_Login>';
            request += '<corp:SSA_Password>pass</corp:SSA_Password>';
            request += '</corp:SSA>';
            request += '<corp:UserDate>';
            request += '<corp:ARX_EDI._UserDefineData>' + FORMAT(salesHdr1."Order Date") + '</corp:ARX_EDI._UserDefineData>';
            request += '</corp:UserDate>';
            request += '</tem:SO>';
            request += '</tem:ImportSO>';
            request += '</soapenv:Body>';
            request += '</soapenv:Envelope>';

        End;
    end;

    procedure SyncSingleOrder(saleshdrs: Record "Sales Header")
    var
        salesHdr1: Record "Sales Header";
        salesLine1: Record "Sales Line";
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
        saleSetup: Record "Sales & Receivables Setup";
        paymentMethod: Record "Payment Method";
        amount: text[50];
        location: Record Location;
        AramexSetups: Record "GTFS Webservice Setup";
        WebServiceResponseMessage: HttpResponseMessage;
        WebServiceResponseText: Text;

    begin
        saleSetup.Get;
        salesHdr1.Reset;
        salesHdr1.SetCurrentKey("Document Type", "No.");
        location.get(saleshdrs."Location Code");
        AramexSetups.Get;

        salesHdr1.SetRange("Document Type", saleshdrs."Document Type");
        salesHdr1.SetRange("No.", saleshdrs."No.");
        salesHdr1.SetRange(Synced, False);
        salesHdr1.SetRange("Location Code", saleshdrs."Location Code");
        salesHdr1.SetFilter("Order Status", '%1', salesHdr1."Order Status"::Exportable);
        salesHdr1.SetRange("Aramex Reference No.", '');

        IF salesHdr1.FindFirst THEN begin
            salesHdr1.CalcFields(salesHdr1."Amount to Customer");
            salesHdr1.CALCFields(salesHdr1."Amount Including VAT");
            // Evaluate(salesHdr1."Amount Including VAT", amount);

            request := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:corp="http://schemas.datacontract.org/2004/07/CORP.DXB.LOG.EDI_WS">';
            request += '<soapenv:Header/>';
            request += '<soapenv:Body>';
            request += '<tem:ImportSO>';
            request += '<tem:SO>';
            request += '<corp:ApplicationHeader>';
            request += '<corp:RequestedDate></corp:RequestedDate>';
            request += '<corp:RequestedSystem></corp:RequestedSystem>';
            request += '<corp:TransactionID>0005</corp:TransactionID>';
            request += '</corp:ApplicationHeader>';
            request += '<corp:DataHeader>';
            request += '<corp:B_Address>';
            request += '<corp:Address1>' + salesHdr1."Sell-to Customer Name" + '</corp:Address1>';
            request += '<corp:Address2>' + salesHdr1."Sell-to Address" + '</corp:Address2>';
            request += '<corp:Address3>' + salesHdr1."Sell-to Country/Region Code" + '</corp:Address3>';
            request += '<corp:City>' + salesHdr1."Sell-to City" + '</corp:City>';
            request += '<corp:Company>' + salesHdr1."Sell-to Customer Name" + '</corp:Company>';
            request += '<corp:Contact>' + salesHdr1."Sell-to Phone No." + '</corp:Contact>';
            request += '<corp:Country>' + salesHdr1."Sell-to Country/Region Code" + '</corp:Country>';
            request += '<corp:Email>' + salesHdr1."Sell-to E-Mail" + '</corp:Email>';
            request += '<corp:Fax>' + salesHdr1."Sell-to Phone No." + '</corp:Fax>';
            request += '<corp:Phone1>' + salesHdr1."Sell-to Phone No." + '</corp:Phone1>';
            request += '<corp:Phone2>' + salesHdr1."Sell-to Phone No." + '</corp:Phone2>';
            request += '      <corp:Ref>' + salesHdr1."No." + '</corp:Ref>';
            request += '<corp:State></corp:State>';
            request += '<corp:ZipCode></corp:ZipCode>';
            request += '</corp:B_Address>';
            request += '<corp:CTSService>COD</corp:CTSService>';
            paymentMethod.get(salesHdr1."Payment Method Code");
            if not paymentMethod.Prepaid THEN
                request += '<corp:CTSValue>' + Format(salesHdr1."Amount Including VAT") + '</corp:CTSValue>'

            else
                request += '<corp:CTSValue>0</corp:CTSValue>';
            request += '<corp:C_Address>';
            request += '<corp:Address1>' + salesHdr1."Ship-to Name" + '</corp:Address1>';
            request += '<corp:Address2>' + salesHdr1."Ship-to Address" + '</corp:Address2>';
            request += '<corp:Address3>' + salesHdr1."Ship-to Address 2" + '</corp:Address3>';
            request += '<corp:City>' + salesHdr1."Ship-to City" + '</corp:City>';
            request += '<corp:Company>' + salesHdr1."Ship-to Name" + '</corp:Company>';
            request += '<corp:Contact>' + salesHdr1."Ship-to Name" + '</corp:Contact>';
            request += '<corp:Country>' + salesHdr1."Ship-to Country/Region Code" + '</corp:Country>';
            request += '<corp:Email>' + salesHdr1."Ship-to E-Mail" + '</corp:Email>';
            request += '<corp:Fax></corp:Fax>';
            request += '<corp:Phone1>' + salesHdr1."Ship-to Phone No." + '</corp:Phone1>';
            request += '<corp:Phone2>' + salesHdr1."Ship-to Phone No." + '</corp:Phone2>';
            request += '<corp:Ref>' + salesHdr1."No." + '</corp:Ref>';
            request += '<corp:State></corp:State>';
            request += '<corp:ZipCode></corp:ZipCode>';
            request += '</corp:C_Address>';
            request += '<corp:ClinetSystemRef>' + salesHdr1."No." + '</corp:ClinetSystemRef>';
            request += '<corp:Currency>' + salesHdr1."Currency Code" + '</corp:Currency>';
            request += '<corp:D_Address>';
            request += '<corp:Address1>' + salesHdr1."Ship-to Name" + '</corp:Address1>';
            request += '<corp:Address2>' + salesHdr1."Ship-to Address" + '</corp:Address2>';
            request += '<corp:Address3>' + salesHdr1."Ship-to Address 2" + '</corp:Address3>';
            request += '<corp:City>' + salesHdr1."Ship-to City" + '</corp:City>';
            request += '<corp:Company>' + salesHdr1."Ship-to Name" + '</corp:Company>';
            request += '<corp:Contact>' + salesHdr1."Ship-to Contact" + '</corp:Contact>';
            request += '<corp:Country>' + salesHdr1."Ship-to Country/Region Code" + '</corp:Country>';
            request += '<corp:Email>' + salesHdr1."Ship-to E-Mail" + '</corp:Email>';
            request += '<corp:Fax>' + salesHdr1."Ship-to Phone No." + '</corp:Fax>';
            request += '<corp:Phone1>' + salesHdr1."Ship-to Phone No." + '</corp:Phone1>';
            request += '<corp:Phone2>' + salesHdr1."Ship-to Phone No." + '</corp:Phone2>';
            request += '<corp:Ref>' + salesHdr1."No." + '</corp:Ref>';
            request += '<corp:State></corp:State>';
            request += '<corp:ZipCode></corp:ZipCode>';
            request += '</corp:D_Address>';
            request += '<corp:Facility>' + location."Aramex Facility" + '</corp:Facility>';
            request += '<corp:Forwarder>aramex</corp:Forwarder>';
            request += '<corp:StorerKey>' + location."Aramex StorerKey" + '</corp:StorerKey>';
            request += '<corp:TransportationMode>' + location."Transportation Mode" + '</corp:TransportationMode>';
            request += '</corp:DataHeader>';
            request += '<corp:DataLines>';
            salesLine1.Reset;
            salesLine1.SetRange("Document Type", salesHdr1."Document Type");
            salesLine1.SetRange("Document No.", salesHdr1."No.");
            salesLine1.Setfilter("Order Status", '<>%1|<>2', salesLine1."Order Status"::Shipped, salesLine1."Order Status"::Canceled);
            salesLine1.SetRange(Type, salesLine1.Type::Item);
            IF salesLine1.FindFirst() THEN
                repeat
                    request += '<corp:ARX_EDI._DataLine_SO>';
                    request += '<corp:ExternLineNo>' + FORMAT(SalesLine1."Line No." / 10000) + '</corp:ExternLineNo>';
                    request += '<corp:Qty>' + Format(salesLine1.Quantity) + '</corp:Qty>';
                    request += '<corp:SKU>' + salesLine1."No." + '</corp:SKU>';
                    request += '<corp:UnitPrice>' + Format(SalesLine1."Unit Price") + '</corp:UnitPrice>';
                    request += '</corp:ARX_EDI._DataLine_SO>';
                    salesLine1."Order Status" := salesLine1."Order Status"::Created;
                    salesLine1.Modify;
                until salesLine1.Next = 0;



            request += '</corp:DataLines>';
            request += '<corp:SSA>';
            request += '<corp:SSA_Login>' + AramexSetups."Aramex EDI Login Id" + '</corp:SSA_Login>';
            request += '<corp:SSA_Password>' + AramexSetups."Aramex EDI Password" + '</corp:SSA_Password>';
            request += '</corp:SSA>';
            request += '<corp:UserDate>';
            request += '<corp:ARX_EDI._UserDefineData></corp:ARX_EDI._UserDefineData>';
            request += '</corp:UserDate>';
            request += '</tem:SO>';
            request += '</tem:ImportSO>';
            request += '</soapenv:Body>';
            request += '</soapenv:Envelope>';


        End;
        url := saleSetup."WhsIntegration API/URL";


        httpContent.GetHeaders(httpHeaders);



        Message(request);
        httpContent.WriteFrom(request);

        httpContent.GetHeaders(httpHeaders);
        httpHeaders.Remove('SOAPAction');
        httpHeaders.Remove('Content-type');
        httpHeaders.Add('Content-type', 'text/xml');
        httpHeaders.Add('SOAPAction', 'http://tempuri.org/IService_EDI/ImportSO');
        //httpHeaders.TryAddWithoutValidation('Action', '*/*');
        httpHeaders.TryAddWithoutValidation('POST', '/WS_EDI_V02/Service_EDI.svc HTTP/1.1');
        httpHeaders.TryAddWithoutValidation('Host', 'portal.infor.aramex.com');
        httpHeaders.TryAddWithoutValidation('Cache-Control', 'no-cache');
        //httpHeaders.TryAddWithoutValidation('accept-encoding', 'gzip, deflate');
        //httpHeaders.TryAddWithoutValidation('Connection', 'keep-alive');
        //httpRequestMessage.GetHeaders(httpHeaders);

        httpRequestMessage.Content := httpContent;
        if httpClient.Post(url, httpContent, httpResponse) then begin
            WebServiceResponseMessage.Content.ReadAs(WebServiceResponseText);
            ProcessXMLResponse(WebServiceResponseText, salesHdr1);
            MESSAGE(httpResponse.ReasonPhrase);
        End Else
            MESSAGE(httpResponse.ReasonPhrase);
        // Message('Error');

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


    var
        myInt: Integer;
        salesHdr: Record "Sales Header";
        SalesLine: Record "Sales Line";
        OrderTrack: Record "Order Tracking Table";
}