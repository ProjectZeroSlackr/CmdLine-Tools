/*
 * custom.h
 *
 * This file is for use on systems where Autoconf isn't quite able to
 * get things right. It is included after config.h in awk.h, to override
 * definitions from Autoconf that are erroneous. See the manual for more
 * information.
 *
 * If you make additions to this file for your system, please send me
 * the information, to arnold@gnu.ai.mit.edu.
 */

/* 
 * Copyright (C) 1995, 96 the Free Software Foundation, Inc.
 * 
 * This file is part of GAWK, the GNU implementation of the
 * AWK Programming Language.
 * 
 * GAWK is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * GAWK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
 */

/* for MIPS RiscOS, from Nelson H. F. Beebe, beebe@math.utah.edu */
#if defined(__host_mips) && defined(SYSTYPE_BSD43)
#undef HAVE_STRTOD
#undef HAVE_STRERROR
#endif

/* for VMS POSIX, from Pat Rankin, rankin@eql.caltech.edu */
#ifdef VMS_POSIX
#undef VMS
#define GETPGRP_VOID	/* autoconf's test for this tries to use
			   `setpgrp()', which doesn't exist.  */
#include "vms/redirect.h"
#endif

/* For QNX, based on submission from Michael Hunter, mphunter@qnx.com */
#ifdef __QNX__
#define GETPGRP_VOID	1
#endif
