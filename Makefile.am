netconfmodule_LTLIBRARIES = libelsys-switch.la

libelsys_switch_la_SOURCES = \
elsys-switch.c

# Depends on installed libyuma-dev
libelsys_switch_la_CPPFLAGS = -I${includedir}/yuma/agt -I${includedir}/yuma/ncx -I${includedir}/yuma/platform $(XML_CPPFLAGS)
libelsys_switch_la_LDFLAGS = -module -lyumaagt -lyumancx

yang_DATA = elsys-switch.yang

bin_SCRIPTS = elsys-switch-set
