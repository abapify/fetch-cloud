class zcl_fetch_badi_cloud definition
  inheriting from zcl_fetch_badi_base
  public
  final
  create public .

  public section.

    interfaces zif_fetch_badi .

  protected section.
  private section.

    methods get_destination importing destination type ref to zif_fetch_destination returning value(result) type ref to if_http_destination
                                                                                    raising
                                                                                      cx_http_dest_provider_error
                                                                                      cx_static_check.
    methods get_method
      importing
                request_method type string
      returning value(result)  type if_web_http_client=>method.
endclass.



class zcl_fetch_badi_cloud implementation.


  method zif_fetch_badi~fetch.

    data(lo_destination) = get_destination( request->destination ).

    data(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
      exporting
        i_destination = lo_destination
    ).

    data(lo_request) = lo_http_client->get_http_request( ).

    " set path
    if request->path is not initial.
      data(current_path) = lo_request->get_header_field( '~request_uri' ).
      lo_request->set_uri_path(
          path=>resolve(
              value #(
                  ( current_path )
                  ( request->path ) ) ) ).
    endif.

    " set body
    if request->body is not initial.
      lo_request->set_binary( request->body ).
    endif.

    " set headers
    lo_request->set_header_fields( corresponding #( request->headers ) ).
    " execute
    data(lo_response) = lo_http_client->execute( get_method( request->method ) ).

    response = new lcl_response( lo_response ).


  endmethod.

  method get_destination.

    case destination->type.
      when destination->destination_types-url.

        data(lo_url_dest) = cast zif_fetch_destination_url( destination ).
        result = cl_http_destination_provider=>create_by_url( i_url = lo_url_dest->url ).

      when destination->destination_types-rfc.

        data(lo_rfc_dest) = cast zif_fetch_destination_rfc( destination ).
        result = cl_http_destination_provider=>create_by_destination( i_destination = lo_rfc_dest->destination ).

      when others.
        throw( 'Not supported destination type' ).
    endcase.


  endmethod.


  method get_method.
    assign if_web_http_client=>(request_method) to field-symbol(<method>).
    result = <method>.
  endmethod.

endclass.
