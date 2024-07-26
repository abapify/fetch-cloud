class zcl_fetch_cloud_delegate definition
inheriting from zcl_fetch_delegate
  public
  final
  create private global friends zcl_fetch_cloud_badi .

  public section.
    interfaces zif_throw.
    aliases throw for zif_throw~throw.
  protected section.
    methods client redefinition.
  private section.
    methods get_destination importing destination type ref to zif_fetch_destination returning value(result) type ref to if_http_destination
                                                                                    raising
                                                                                      cx_http_dest_provider_error
                                                                                      cx_static_check.
endclass.

class zcl_fetch_cloud_delegate implementation.
  method client.
    data(http_destination) = get_destination( destination ).
    data(http_client) = cl_web_http_client_manager=>create_by_http_destination(
      exporting
        i_destination = http_destination
    ).
    result = new zcl_fetch_cloud_client( http_client = http_client ).
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
  method zif_throw~throw.
    new zcl_throw( )->throw( message ).
  endmethod.

endclass.
