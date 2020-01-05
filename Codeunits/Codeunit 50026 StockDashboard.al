Codeunit 50026 StockDashboard
{
    trigger OnRun();
    begin
    end;

    var
        stockDashboard: Record "StockDashboards";

    procedure UpdateShipmentTracking(OrderNo: code[20])
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonArray: JsonArray;
        trackingLine: JsonToken;
        entity_id: JsonToken;
        increment_id: JsonToken;
        parent_id: JsonToken;
        order_id: JsonToken;
        track_number: JsonToken;
        carrier_code: JsonToken;
        label_url: JsonToken;
        JsonResponse: JsonObject;
        request: Text;
        whsShipment: Record "Warehouse Shipment Header";
        awbIntegration: Record AWBIntegrationV3;
        responseSample: Text;
        i: Integer;
        whsShipmentLine: Record "Warehouse Shipment Line";
        itemsInShipment: Text;
        carrier: Text;
        DammanQty: Integer;
        JeddahQty: Integer;
        DXBQty: Integer;
    begin
        stockDashboard.Reset;

        stockDashboard.SetFilter(Quantity, '<>0');
        if stockDashboard.FindFirst then
            repeat
                IF stockDashboard.Location = 'GS-DMM' then
                    DammanQty := stockDashboard.Quantity;
                IF stockDashboard.Location = 'GS-JDH' then
                    JeddahQty := stockDashboard.Quantity;
                IF stockDashboard.Location = 'GS-DXB' then
                    DXBQty := stockDashboard.Quantity;
            until stockDashboard.next = 0;

        request :=
       ' {"api_key": "d3a43373b71b1fbb93b51228475092cf", "data": {"item": [{"text": "Dammam", "value": "' + format(DammanQty) + '"}, {"text": "Jeddah", "value": "' + format(JeddahQty) + '"}, {"text": "Dubai", "value": "' + format(DXBQty) + '"}]}}';
        responseSample := getHttpResponse('https://push.geckoboard.com/v1/send/761753-47891280-e352-0137-6e35-025a7fb2af0f', request);
        JsonResponse.ReadFrom(responseSample);
        Message(responseSample);
        //JsonToken.ReadFrom(responseText);
        //JsonToken.SelectToken('increment_id', JsonToken);
        //parsing json response
    end; //for end



    local procedure getHttpResponse(url: Text;

    request: Text): Text
    var
        consumerKey: Text;
        consumerSecret: Text;
        accessToken: Text;
        accessSecret: Text;
        content: HttpContent;
        responseText: Text;
        HttpClinet: HttpClient;
        ResponseMessag: HttpResponseMessage;
        contentHeader: HttpHeaders;
        requestMessage: HttpRequestMessage;
        httpHeader: HttpHeaders;

    begin
        consumerKey := '0b1c32ab2f679b95ad370b2663a0165e';
        consumerSecret := '6400d0704d3326805cb9378ca834a92c';
        accessToken := 'a7c05e72e705f90228c3715b8d3baa39';
        accessSecret := '6e9c2a01290e965d0a0bbd5001f4a98d';
        url := 'https://push.geckoboard.com/v1/send/761753-47891280-e352-0137-6e35-025a7fb2af0f';

        //request := '{"increment_id":"200443116","carrier":"smsa","items_qty":["SA1677203-1"]}';
        //whsShipment.Reset();
        //whsShipment.
        content.GetHeaders(contentHeader);
        content.WriteFrom(request);
        contentHeader.Remove('Content-Type');
        contentHeader.Add('Content-Type', 'application/json');
        requestMessage.Content(content);
        requestMessage.SetRequestUri(url);
        requestMessage.GetHeaders(httpHeader);
        requestMessage.Method('POST');

        HttpClinet.Post(url, content, ResponseMessag);
        ResponseMessag.Content.ReadAs(responseText);
        exit(responseText);
    end;

    procedure SendStock()
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonArray: JsonArray;
        trackingLine: JsonToken;
        entity_id: JsonToken;
        increment_id: JsonToken;
        parent_id: JsonToken;
        order_id: JsonToken;
        track_number: JsonToken;
        carrier_code: JsonToken;
        label_url: JsonToken;
        JsonResponse: JsonObject;
        request: Text;
        whsShipment: Record "Warehouse Shipment Header";
        awbIntegration: Record AWBIntegrationV3;
        responseSample: Text;
        i: Integer;
        whsShipmentLine: Record "Warehouse Shipment Line";
        itemsInShipment: Text;
        carrier: Text;
        DammanQty: Integer;
        JeddahQty: Integer;
        DXBQty: Integer;
    begin
        stockDashboard.Reset;

        stockDashboard.SetFilter(Quantity, '<>0');
        if stockDashboard.FindFirst then
            repeat
                IF stockDashboard.Location = 'GS-DMM' then
                    DammanQty := stockDashboard.Quantity;
                IF stockDashboard.Location = 'GS-JDH' then
                    JeddahQty := stockDashboard.Quantity;
                IF stockDashboard.Location = 'GS-DXB' then
                    DXBQty := stockDashboard.Quantity;
            until stockDashboard.next = 0;

        request :=
       ' {"api_key": "d3a43373b71b1fbb93b51228475092cf", "data": {"item": [{"text": "Dammam", "value": "' + format(DammanQty) + '"}, {"text": "Jeddah", "value": "' + format(JeddahQty) + '"}, {"text": "Dubai", "value": "' + format(DXBQty) + '"}]}}';
        Message(request);
        responseSample := getHttpResponse('https://push.geckoboard.com/v1/send/761753-47891280-e352-0137-6e35-025a7fb2af0f', request);
        JsonResponse.ReadFrom(responseSample);
        Message(responseSample);
        //JsonToken.ReadFrom(responseText);
        //JsonToken.SelectToken('increment_id', JsonToken);
        //parsing json response
    end; //for end

    procedure SendValue()
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonArray: JsonArray;
        trackingLine: JsonToken;
        entity_id: JsonToken;
        increment_id: JsonToken;
        parent_id: JsonToken;
        order_id: JsonToken;
        track_number: JsonToken;
        carrier_code: JsonToken;
        label_url: JsonToken;
        JsonResponse: JsonObject;
        request: Text;
        whsShipment: Record "Warehouse Shipment Header";
        awbIntegration: Record AWBIntegrationV3;
        responseSample: Text;
        i: Integer;
        whsShipmentLine: Record "Warehouse Shipment Line";
        itemsInShipment: Text;
        carrier: Text;
        DammanQty: Integer;
        JeddahQty: Integer;
        DXBQty: Integer;
        DMMMVal: Decimal;
        JDHVal: Decimal;
        DXBVal: Decimal;
        damVal: BigInteger;
        jedVal: BigInteger;
        dxbVal1: BigInteger;

    begin
        stockDashboard.Reset;

        stockDashboard.SetFilter(Quantity, '<>0');
        if stockDashboard.FindFirst then
            repeat
                IF stockDashboard.Location = 'GS-DMM' then
                    damVal := round(stockDashboard.StockValue, 1);
                IF stockDashboard.Location = 'GS-JDH' then
                    jedVal := round(stockDashboard.StockValue, 1);
                IF stockDashboard.Location = 'GS-DXB' then
                    dxbVal1 := Round(stockDashboard.StockValue, 1);
            until stockDashboard.next = 0;

        request :=
       ' {"api_key": "d3a43373b71b1fbb93b51228475092cf", "data": {"item": [{"text": "Dammam", "value": "' + format(damVal) + '"}, {"text": "Jeddah", "value": "' + format(jedVal) + '"}, {"text": "Dubai", "value": "' + format(dxbVal1) + '"}]}}';
        Message(request);
        responseSample := getHttpResponseVAL('https://push.geckoboard.com/v1/send/761753-b5d6b6d0-e90d-0137-e506-0e2a7225594c', request);
        JsonResponse.ReadFrom(responseSample);
        Message(responseSample);
        //JsonToken.ReadFrom(responseText);
        //JsonToken.SelectToken('increment_id', JsonToken);
        //parsing json response
    end; //for end

    local procedure getHttpResponseVAL(url: Text;

    request: Text): Text
    var
        consumerKey: Text;
        consumerSecret: Text;
        accessToken: Text;
        accessSecret: Text;
        content: HttpContent;
        responseText: Text;
        HttpClinet: HttpClient;
        ResponseMessag: HttpResponseMessage;
        contentHeader: HttpHeaders;
        requestMessage: HttpRequestMessage;
        httpHeader: HttpHeaders;

    begin
        consumerKey := '0b1c32ab2f679b95ad370b2663a0165e';
        consumerSecret := '6400d0704d3326805cb9378ca834a92c';
        accessToken := 'a7c05e72e705f90228c3715b8d3baa39';
        accessSecret := '6e9c2a01290e965d0a0bbd5001f4a98d';
        url := 'https://push.geckoboard.com/v1/send/761753-b5d6b6d0-e90d-0137-e506-0e2a7225594c';

        //request := '{"increment_id":"200443116","carrier":"smsa","items_qty":["SA1677203-1"]}';
        //whsShipment.Reset();
        //whsShipment.
        content.GetHeaders(contentHeader);
        content.WriteFrom(request);
        contentHeader.Remove('Content-Type');
        contentHeader.Add('Content-Type', 'application/json');
        requestMessage.Content(content);
        requestMessage.SetRequestUri(url);
        requestMessage.GetHeaders(httpHeader);
        requestMessage.Method('POST');

        HttpClinet.Post(url, content, ResponseMessag);
        ResponseMessag.Content.ReadAs(responseText);
        exit(responseText);
    end;




}
