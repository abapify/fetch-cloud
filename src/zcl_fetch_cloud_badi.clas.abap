class zcl_fetch_cloud_badi definition
  inheriting from zcl_fetch_badi_base
  public
  final
  create public .

  public section.

  protected section.

    methods delegate redefinition.

  private section.

endclass.

class zcl_fetch_cloud_badi implementation.
  method delegate.
    result = new zcl_fetch_cloud_delegate( destination = destination ).
  endmethod.
endclass.
