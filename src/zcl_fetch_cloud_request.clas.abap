class zcl_fetch_cloud_request definition
  public
  final
  create private global friends zcl_fetch_cloud_client .

  public section.
    interfaces zif_fetch_request_setter.
    methods constructor importing http_request type ref to if_web_http_request.
  protected section.
  private section.
    data http_request type ref to if_web_http_request.
    data method type string.
endclass.

class zcl_fetch_cloud_request implementation.

  method constructor.
    assert http_request is bound.
    super->constructor( ).
    me->http_request = http_request.
  endmethod.

  method zif_fetch_request_setter~body.
    check body is not initial.
    me->http_request->set_binary( body ).
  endmethod.

  method zif_fetch_request_setter~headers.
    me->http_request->set_header_fields(
      exporting
        i_fields = corresponding #( headers )
    ).
  endmethod.

  method zif_fetch_request_setter~method.
    " it's not stored in the request but provided during execute as input parameter
    me->method = method.
  endmethod.

  method zif_fetch_request_setter~path.
    " set path
    if path is not initial.
      data(current_path) = http_request->get_header_field( '~request_uri' ).
      http_request->set_uri_path(
          path=>resolve(
              value #(
                  ( current_path )
                  ( path ) ) ) ).
    endif.
  endmethod.

  method zif_fetch_request_setter~header.

    me->http_request->set_header_field(
      exporting
        i_name  = name
        i_value = value
    ).

  endmethod.

  method zif_fetch_entity_readable~body.
    result = me->http_request->get_binary( ).
  endmethod.

  method zif_fetch_entity_readable~header.
    value =  me->http_request->get_header_field( name ).
  endmethod.

  method zif_fetch_entity_readable~headers.
    headers = corresponding #( me->http_request->get_header_fields( ) ).
  endmethod.

  method zif_fetch_request~method.
    result = me->method.
  endmethod.

  method zif_fetch_request~path.
    result = me->zif_fetch_entity_readable~header( '~request_uri' ).
  endmethod.

  method zif_fetch_entity_readable~text.
    result = me->http_request->get_text( ).
  endmethod.

  method zif_fetch_entity_writeable~text.
    me->http_request->set_text( text ).
  endmethod.

endclass.
