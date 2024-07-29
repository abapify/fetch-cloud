class zcl_fetch_cloud_client definition
  public
  final
   create private global friends zcl_fetch_cloud_delegate .
  public section.
    interfaces zif_fetch_client.
    methods constructor importing http_client type ref to if_web_http_client.
  private section.
    data http_client type ref to if_web_http_client .
    methods get_method
      importing
                request_method type string
      returning value(result)  type if_web_http_client=>method.
endclass.



class zcl_fetch_cloud_client implementation.

  method zif_fetch_client~fetch.
    " execute
    data(method) = get_method( request->method( ) ).
    data(http_response) = me->http_client->execute( method ).
    response = new zcl_fetch_cloud_response( http_response = http_response ).
  endmethod.
  method zif_fetch_client~request.
    result = new zcl_fetch_cloud_request( me->http_client->get_http_request( ) ).
  endmethod.
  method get_method.
    assign if_web_http_client=>(request_method) to field-symbol(<method>).
    result = <method>.
  endmethod.

  method constructor.
    assert http_client is bound.
    super->constructor( ).
    me->http_client = http_client.
  endmethod.

endclass.
