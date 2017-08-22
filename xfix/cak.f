      program cak
      character*40 fmt,buffer
      double precision tmp

      fmt = 'cprint%%: %s %d %f\n~'
      buffer = 'This is a load of cak~'
      n = 1
      x = 3.141
      tmp = dble(x)
      call cprint (fmt, buffer, %val(n), %val(tmp))

      stop 
      end
