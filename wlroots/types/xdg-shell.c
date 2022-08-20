#include <libguile.h>
#include <wlr/types/wlr_xdg_shell.h>
#include "../helper.c"

SCM_DEFINE(scm_wlr_xdg_surface_toplevel ,"wlr-xdg-surface-toplevel",1,0,0,(SCM o),"")
{
  return WRAP_WLR_XDG_TOPLEVEL(((struct wlr_xdg_surface*)(UNWRAP_WLR_XDG_SHELL(o)))->toplevel);
}

SCM_DEFINE(scm_wlr_xdg_toplevel_appid ,"wlr-xdg-toplevel-appid",1,0,0,(SCM o),"")
{
  return scm_from_locale_string(((struct wlr_xdg_toplevel*)(UNWRAP_WLR_XDG_TOPLEVEL(o)))->app_id);
}


void
scm_init_wlr_xdg_shell(void)
{
#ifndef SCM_MAGIC_SNARFER
#include "xdg-shell.x"
#endif
}
