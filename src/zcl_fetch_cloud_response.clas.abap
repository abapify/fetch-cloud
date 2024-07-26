class zcl_fetch_cloud_response definition
  public
  final
  create private global friends zcl_fetch_cloud_client .

  public section.
    interfaces zif_fetch_response.
    methods constructor importing http_response type ref to if_web_http_response.
  private section.
    data http_response type ref to if_web_http_response.
endclass.


class zcl_fetch_cloud_response implementation.
  method zif_fetch_response~body.
    result = me->http_response->get_binary( ).
  endmethod.

  method zif_fetch_response~text.
    result = me->http_response->get_text( ).
  endmethod.

  method zif_fetch_response~header.
    value = me->http_response->get_header_field( i_name = name ).
  endmethod.

  method zif_fetch_response~headers.
    headers = corresponding #( me->http_response->get_header_fields( ) ).
  endmethod.

  method zif_fetch_response~status.
    result = me->http_response->get_status( )-code.
  endmethod.

  method zif_fetch_response~status_text.
    result = me->http_response->get_status( )-reason.
  endmethod.
  method constructor.
    assert http_response is bound.
    super->constructor( ).
    me->http_response = http_response.
  endmethod.

endclass.
