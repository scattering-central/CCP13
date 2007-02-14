      subroutine strippath(fnam2,fnam,path,iflag)

      character*80 fnam2
      character*13 fnam
      character*80 path
      integer iflag

      integer i

      iflag=0

      do 10 i=1,80
        if(fnam2(i:i).eq.'/')then
          iflag=i
        endif
10    continue

      fnam=fnam2(iflag+1:iflag+14)

      if(iflag.gt.0)then
        path=fnam2(1:iflag)
      endif

      return
      end
