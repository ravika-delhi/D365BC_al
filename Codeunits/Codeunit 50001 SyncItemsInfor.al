codeunit 50001 SyncItemsInfor
{
    trigger OnRun()
    var
        itemT: record Item;
    begin
        itemT.Reset;
        itemT.Setfilter("No.", '<>%1', '');
        itemT.Setrange(SyncedWMS, false);
        If itemT.FindFirst() then
            AllSkuNdays(itemT);

    end;

    var

    procedure NewSKus(itemCode: code[20])
    var
        ItemN: Record Item;
        ItemM: Record Item;
        request: Text;
        url: Text;
        ResponseInStream: InStream;
        location: Record Location;
        httpClient: HttpClient;
        httpContent: HttpContent;
        httpHeaders: HttpHeaders;
        httpHdr: HttpHeaders;
        httpResponse: HttpResponseMessage;
        httpRequestMessage: HttpRequestMessage;
        AramexSetup: Record "GTFS Webservice Setup";
        salesSetup: Record "Sales & Receivables Setup";
    begin
        salesSetup.get();
        AramexSetup.get();
        ItemN.Reset;
        location.get(salesSetup."Default Location Code");
        //ItemN.Setrange("Last Date Modified", CALCDATE('-3D', TODAY), TODAY);
        ItemN.Setrange("No.", itemCode);
        IF ItemN.FindFirst then begin
            request := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"	 xmlns:tem="http://tempuri.org/" xmlns:corp="http://schemas.datacontract.org/2004/07/CORP.DXB.LOG.EDI_WS">';
            request += '<soapenv:Header/>';
            request += '<soapenv:Body>';
            request += '<tem:ImportSKU>';
            request += '<tem:SKU>';
            request += '<corp:ApplicationHeader>';
            request += '<corp:RequestedDate></corp:RequestedDate>';
            request += '<corp:RequestedSystem>Test</corp:RequestedSystem>';
            request += '<corp:TransactionID>NewItemMrequest</corp:TransactionID>';
            request += '</corp:ApplicationHeader>';
            request += '<corp:DataHeader>';
            request += '<corp:Description>' + ItemN.ProductName + '</corp:Description>';
            request += '<corp:Facility>WMWHSE7</corp:Facility>';
            request += '<corp:HSCode></corp:HSCode>';
            request += '<corp:SKU>' + ItemN."No." + '</corp:SKU>';
            request += '<corp:SUSR6>' + ItemN."Item_type(Conc)" + '</corp:SUSR9>';
            request += '<corp:SUSR7>' + ItemN.Gender + '</corp:SUSR9>';
            request += '<corp:SUSR7>' + ItemN.BrandCode + '</corp:SUSR9>';
            request += '<corp:SUSR9>' + salesSetup.MegentoUrl + ItemN.urlImgae + '</corp:SUSR9>';

            request += '<corp:SUSR9>' + salesSetup.MegentoUrl + ItemN.urlImgae + '</corp:SUSR9>';
            request += '<corp:SerialCount>0</corp:SerialCount>';
            request += '<corp:StorerKey>GOLDEN_SCENT</corp:StorerKey>';
            request += '<corp:UPC>' + ItemN."Vendor Item No." + '</corp:UPC>';
            request += '</corp:DataHeader>';
            request += '<corp:SSA>';
            request += '<corp:SSA_Login>' + AramexSetup."Aramex EDI Login Id" + '</corp:SSA_Login>';
            request += '<corp:SSA_Password>' + AramexSetup."Aramex EDI Password" + '</corp:SSA_Password>';
            request += '</corp:SSA>';
            request += '<corp:UserDate>';
            request += '</corp:UserDate>';
            request += '</tem:SKU>';
            request += '</tem:ImportSKU>';
            request += '</soapenv:Body>';
            request += '</soapenv:Envelope>';
            ItemN.SyncedWMS := True;
            ItemN.Synced_at := CurrentDateTime;
            ItemN.Modify();

        end;
        //Message(request);
        url := salesSetup."WhsIntegration API/URL";


        httpContent.GetHeaders(httpHeaders);




        httpContent.WriteFrom(request);

        httpContent.GetHeaders(httpHeaders);
        httpHeaders.Remove('SOAPAction');
        httpHeaders.Remove('Content-type');
        httpHeaders.Add('Content-type', 'text/xml');
        httpHeaders.Add('SOAPAction', 'http://tempuri.org/IService_EDI/ImportSKU');
        httpHeaders.TryAddWithoutValidation('Action', '*/*');
        httpHeaders.TryAddWithoutValidation('POST', '/WS_EDI_TEST_V02/Service_EDI.svc HTTP/1.1');
        httpHeaders.TryAddWithoutValidation('Host', 'portal.infor.aramex.com');
        httpHeaders.TryAddWithoutValidation('Cache-Control', 'no-cache');
        httpHeaders.TryAddWithoutValidation('accept-encoding', 'gzip, deflate');
        httpHeaders.TryAddWithoutValidation('Connection', 'keep-alive');
        //httpRequestMessage.GetHeaders(httpHeaders);

        httpRequestMessage.Content := httpContent;
        if not httpClient.Post(url, httpContent, httpResponse) then
            MESSAGE(httpResponse.ReasonPhrase);
        /*Else
            Message('Error');*/

        /* httpRequestMessage.Method('POST');
         httpRequestMessage.SetRequestUri(url);


         IF httpClient.Send(httpRequestMessage, httpResponse) then
             MESSAGE(httpResponse.ReasonPhrase)
         Else
             Message('Error');*/




    end;


    procedure AllSkuNdays(recItem: Record Item)
    var
        ItemN: Record Item;
        ItemM: Record Item;
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
        myint := 0;
        saleSetup.get;
        Locset.get(saleSetup."Default Location Code");
        AramexSetup.get;
        // ItemN.Setrange("Last Date Modified", CALCDATE('-100D', TODAY), TODAY);



        //If ItemN.FindFirst Then Begin
        request := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"	 xmlns:tem="http://tempuri.org/" xmlns:corp="http://schemas.datacontract.org/2004/07/CORP.DXB.LOG.EDI_WS">';
        request += '<soapenv:Header/>';
        request += '<soapenv:Body>';
        request += '<tem:ImportSKUs>';
        request += '<tem:SKUs>';
        request += '<corp:ApplicationHeader>';
        request += '<corp:RequestedDate></corp:RequestedDate>';
        request += '<corp:RequestedSystem>Test</corp:RequestedSystem>';
        request += '<corp:TransactionID>NewItemMrequest1</corp:TransactionID>';
        request += '</corp:ApplicationHeader>';

        request += '<corp:DataHeader>';
        ItemN.RESET;
        ItemN.Setrange(SyncedWMS, False);
        ItemM.SetFilter("No.", '<>%1', '-');
        IF ItemN.Findset then
            repeat

                request += '<corp:ARX_EDI._DataHeader_SKU>';
                request += '<corp:Description>' + ItemN.ProductName + '</corp:Description>';
                request += '<corp:Facility>' + Locset."Aramex Facility" + '</corp:Facility>';
                request += '<corp:HSCode></corp:HSCode>';
                request += '<corp:SKU>' + ItemN."No." + '</corp:SKU>';
                request += '<corp:SUSR6>' + ItemN."Item_type(Conc)" + '</corp:SUSR9>';
                request += '<corp:SUSR7>' + ItemN.Gender + '</corp:SUSR9>';
                request += '<corp:SUSR7>' + ItemN.BrandCode + '</corp:SUSR9>';
                request += '<corp:SUSR9>' + saleSetup.MegentoUrl + ItemN.urlImgae + '</corp:SUSR9>';
                request += '<corp:SerialCount>0</corp:SerialCount>';
                request += '<corp:StorerKey>GOLDEN_SCENT</corp:StorerKey>';
                request += '<corp:UPC>' + ItemN."Vendor Item No." + '</corp:UPC>';
                request += '</corp:ARX_EDI._DataHeader_SKU>';
                ItemN.SyncedWMS := True;
                ItemN.Synced_at := CurrentDateTime;
                ItemN.Modify(True);
                myint := myint + 1;
            until (ItemN.Next = 0) or (myint >= 200);


        request += '</corp:DataHeader>';
        request += '<corp:SSA>';
        request += '<corp:SSA_Login>' + AramexSetup."Aramex EDI Login Id" + '</corp:SSA_Login>';
        request += '<corp:SSA_Password>' + AramexSetup."Aramex EDI Password" + '</corp:SSA_Password>';
        request += '</corp:SSA>';
        request += '<corp:UserDate>';
        request += '</corp:UserDate>';
        request += '</tem:SKUs>';
        request += '</tem:ImportSKUs>';
        request += '</soapenv:Body>';
        request += '</soapenv:Envelope>';


        // Message(request);

        // url := AramexSetup."Aramex EDI Webservice URL";
        url := saleSetup."WhsIntegration API/URL";


        httpContent.GetHeaders(httpHeaders);




        httpContent.WriteFrom(request);

        httpContent.GetHeaders(httpHeaders);
        httpHeaders.Remove('SOAPAction');
        httpHeaders.Remove('Content-type');
        httpHeaders.Add('Content-type', 'text/xml');
        httpHeaders.Add('SOAPAction', 'http://tempuri.org/IService_EDI/ImportSKUs');
        httpHeaders.TryAddWithoutValidation('Action', '*/*');
        httpHeaders.TryAddWithoutValidation('POST', '/WS_EDI_TEST_V02/Service_EDI.svc HTTP/1.1');
        httpHeaders.TryAddWithoutValidation('Host', 'portal.infor.aramex.com');
        httpHeaders.TryAddWithoutValidation('Cache-Control', 'no-cache');
        httpHeaders.TryAddWithoutValidation('accept-encoding', 'gzip, deflate');
        httpHeaders.TryAddWithoutValidation('Connection', 'keep-alive');
        //httpRequestMessage.GetHeaders(httpHeaders);

        httpRequestMessage.Content := httpContent;
        if httpClient.Post(url, httpContent, httpResponse) then
            MESSAGE(httpResponse.ReasonPhrase)
        Else
            Message(httpResponse.ReasonPhrase);

    end;
}