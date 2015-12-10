module Sys
  class Uname
    lib LibC
      ifdef linux
        UTSNAME_STR_SIZE = 65
      else
        UTSNAME_STR_SIZE = 256
      end

      struct Utsname
        sysname : LibC::Char[UTSNAME_STR_SIZE]
        nodename : LibC::Char[UTSNAME_STR_SIZE]
        release : LibC::Char[UTSNAME_STR_SIZE]
        version : LibC::Char[UTSNAME_STR_SIZE]
        machine : LibC::Char[UTSNAME_STR_SIZE]
        ifdef linux
          domainname : LibC::Char[UTSNAME_STR_SIZE]
        end
      end

      fun uname(buf: Pointer(Utsname)) : Int32
    end

    getter sysname, nodename, release, version, machine

    def initialize
      if LibC.uname(out buf) != 0
        raise Errno.new("uname")
      end

      @sysname = String.new(buf.sysname.to_unsafe)
      @nodename = String.new(buf.nodename.to_unsafe)
      @release = String.new(buf.release.to_unsafe)
      @version = String.new(buf.version.to_unsafe)
      @machine = String.new(buf.machine.to_unsafe)

      ifdef linux
        @domain = String.new(buf.domainname.to_unsafe)
      end
    end

    def domainname
      ifdef linux
        @domain
      else
        raise "Not implemented"
      end
    end
  end
end
