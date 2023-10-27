(*
 * The Clear BSD License
 * 
 * Copyright (c) 2023 XXIV
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted (subject to the limitations in the disclaimer
 * below) provided that the following conditions are met:
 * 
 *      * Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * 
 *      * Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 * 
 *      * Neither the name of the copyright holder nor the names of its
 *      contributors may be used to endorse or promote products derived from this
 *      software without specific prior written permission.
 * 
 * NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
 * THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *)
unit mocha;

{$ifdef fpc}
{$packrecords c}
{$endif}

interface

uses ctypes;

type
   Pmocha_array_t  = ^mocha_array_t;
   Pmocha_object_t  = ^mocha_object_t;
   Pmocha_reference_t  = ^mocha_reference_t;
   Pmocha_value_t  = ^mocha_value_t;
   mocha_error_t = (MOCHA_ERROR_NONE,MOCHA_ERROR_MISSING_FIELD,
		    MOCHA_ERROR_DUPLICATE_FIELD,MOCHA_ERROR_ROOT_REFERENCE,
		    MOCHA_ERROR_OUT_OF_MEMORY,MOCHA_ERROR_INVALID_CHARACTER,
		    MOCHA_ERROR_OVERFLOW,MOCHA_ERROR_END_OF_STREAM,
		    MOCHA_ERROR_UNEXPECTED_TOKEN,MOCHA_ERROR_UNEXPECTED_CHARACTER
		    );

mocha_value_type_t = (MOCHA_VALUE_TYPE_NIL,MOCHA_VALUE_TYPE_STRING,
		      MOCHA_VALUE_TYPE_REFERENCE,MOCHA_VALUE_TYPE_BOOLEAN,
		      MOCHA_VALUE_TYPE_OBJECT,MOCHA_VALUE_TYPE_ARRAY,
		      MOCHA_VALUE_TYPE_FLOAT64,MOCHA_VALUE_TYPE_INTEGER64
		      );
mocha_reference_t = record
		      name_ : Pchar;
		      name_len : csize_t;
		      child : pointer;
		      index_ : csize_t;
		    end;
mocha_array_t = record
		  items : pointer;
		  items_len : csize_t;
	        end;
mocha_object_t = record
		   fields : pointer;
		   fields_len : csize_t;
		 end;
mocha_value_t = record
		  case longint of
		    0 : ( string_ : Pchar );
		    1 : ( reference : mocha_reference_t );
		    2 : ( boolean_ : longint );
		    3 : ( object_ : mocha_object_t );
		    4 : ( array_ : mocha_array_t );
		    5 : ( float64 : double );
		    6 : ( integer64 : cslonglong );
		end;
mocha_field_t = record
		  name_ : Pchar;
		  value : mocha_value_t;
                  type_ : mocha_value_type_t;
	        end;

function mocha_parse(object_:Pmocha_object_t; src:Pchar):mocha_error_t;cdecl;external;

function mocha_nparse(object_:Pmocha_object_t; src:Pchar; len:csize_t):mocha_error_t;cdecl;external;

procedure mocha_deinit(object_:Pmocha_object_t);cdecl;external;

function mocha_field(object_:Pmocha_object_t; index_:csize_t):mocha_field_t;cdecl;external;

function mocha_array(array_:Pmocha_array_t; value:Pmocha_value_t; index_:csize_t):mocha_value_type_t;cdecl;external;

function mocha_reference_next(reference:Pmocha_reference_t):longint;cdecl;external;

implementation

end.
