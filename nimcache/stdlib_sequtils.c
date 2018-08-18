/* Generated by Nim Compiler v0.18.0 */
/*   (c) 2018 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Linux, amd64, gcc */
/* Command for C compiler:
   gcc -c  -w  -I/home/adam/.choosenim/toolchains/nim-0.18.0/lib -o /home/adam/Documents/Projects/nim-hashids/nimcache/stdlib_sequtils.o /home/adam/Documents/Projects/nim-hashids/nimcache/stdlib_sequtils.c */
#define NIM_NEW_MANGLING_RULES
#define NIM_INTBITS 64

#include "nimbase.h"
#undef LANGUAGE_C
#undef MIPSEB
#undef MIPSEL
#undef PPC
#undef R3000
#undef R4000
#undef i386
#undef linux
#undef mips
#undef near
#undef powerpc
#undef unix
typedef struct tySequence_qwqHTkRvwhrRyENtudHQ7g tySequence_qwqHTkRvwhrRyENtudHQ7g;
typedef struct TGenericSeq TGenericSeq;
typedef struct TNimType TNimType;
typedef struct TNimNode TNimNode;
typedef struct NimStringDesc NimStringDesc;
struct TGenericSeq {
NI len;
NI reserved;
};
typedef NU8 tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A;
typedef NU8 tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ;
typedef N_NIMCALL_PTR(void, tyProc_ojoeKfW4VYIm36I9cpDTQIg) (void* p, NI op);
typedef N_NIMCALL_PTR(void*, tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ) (void* p);
struct TNimType {
NI size;
tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A kind;
tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ flags;
TNimType* base;
TNimNode* node;
void* finalizer;
tyProc_ojoeKfW4VYIm36I9cpDTQIg marker;
tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ deepcopy;
};
typedef NU8 tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ;
struct TNimNode {
tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ kind;
NI offset;
TNimType* typ;
NCSTRING name;
NI len;
TNimNode** sons;
};
struct NimStringDesc {
  TGenericSeq Sup;
NIM_CHAR data[SEQ_DECL_SIZE];
};
struct tySequence_qwqHTkRvwhrRyENtudHQ7g {
  TGenericSeq Sup;
  NI data[SEQ_DECL_SIZE];
};
N_NOINLINE(void, raiseIndexError)(void);
static N_INLINE(NI, addInt)(NI a, NI b);
N_NOINLINE(void, raiseOverflow)(void);
static N_INLINE(NI, chckRange)(NI i, NI a, NI b);
N_NOINLINE(void, raiseRangeError)(NI64 val);
N_NIMCALL(void*, newSeq)(TNimType* typ, NI len);
N_LIB_PRIVATE N_NIMCALL(void, failedAssertImpl_aDmpBTs9cPuXp0Mp9cfiNeyA)(NimStringDesc* msg);
static N_INLINE(void, nimFrame)(TFrame* s);
N_LIB_PRIVATE N_NOINLINE(void, stackOverflow_II46IjNZztN9bmbxUD8dt8g)(void);
static N_INLINE(void, popFrame)(void);
extern TNimType NTI_qwqHTkRvwhrRyENtudHQ7g_;
extern TFrame* framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;
STRING_LITERAL(TM_77ITQxrABVT9b2GcbWeV4SQ_6, "len(a) == L seq modified while iterating over it", 48);

static N_INLINE(NI, addInt)(NI a, NI b) {
	NI result;
{	result = (NI)0;
	result = (NI)((NU64)(a) + (NU64)(b));
	{
		NIM_BOOL T3_;
		T3_ = (NIM_BOOL)0;
		T3_ = (((NI) 0) <= (NI)(result ^ a));
		if (T3_) goto LA4_;
		T3_ = (((NI) 0) <= (NI)(result ^ b));
		LA4_: ;
		if (!T3_) goto LA5_;
		goto BeforeRet_;
	}
	LA5_: ;
	raiseOverflow();
	}BeforeRet_: ;
	return result;
}

static N_INLINE(NI, chckRange)(NI i, NI a, NI b) {
	NI result;
{	result = (NI)0;
	{
		NIM_BOOL T3_;
		T3_ = (NIM_BOOL)0;
		T3_ = (a <= i);
		if (!(T3_)) goto LA4_;
		T3_ = (i <= b);
		LA4_: ;
		if (!T3_) goto LA5_;
		result = i;
		goto BeforeRet_;
	}
	goto LA1_;
	LA5_: ;
	{
		raiseRangeError(((NI64) (i)));
	}
	LA1_: ;
	}BeforeRet_: ;
	return result;
}

static N_INLINE(void, nimFrame)(TFrame* s) {
	NI T1_;
	T1_ = (NI)0;
	{
		if (!(framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw == NIM_NIL)) goto LA4_;
		T1_ = ((NI) 0);
	}
	goto LA2_;
	LA4_: ;
	{
		T1_ = ((NI) ((NI16)((*framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw).calldepth + ((NI16) 1))));
	}
	LA2_: ;
	(*s).calldepth = ((NI16) (T1_));
	(*s).prev = framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;
	framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw = s;
	{
		if (!((*s).calldepth == ((NI16) 2000))) goto LA9_;
		stackOverflow_II46IjNZztN9bmbxUD8dt8g();
	}
	LA9_: ;
}

static N_INLINE(void, popFrame)(void) {
	framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw = (*framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw).prev;
}

N_LIB_PRIVATE N_NIMCALL(tySequence_qwqHTkRvwhrRyENtudHQ7g*, concat_kqTRt61Df52wxQcUXDS7aQ)(tySequence_qwqHTkRvwhrRyENtudHQ7g** seqs, NI seqsLen_0) {
	tySequence_qwqHTkRvwhrRyENtudHQ7g* result;
	NI L;
	NI i_2;
	nimfr_("concat", "sequtils.nim");
	result = (tySequence_qwqHTkRvwhrRyENtudHQ7g*)0;
	nimln_(40, "sequtils.nim");
	L = ((NI) 0);
	{
		tySequence_qwqHTkRvwhrRyENtudHQ7g* seqitm;
		NI i;
		seqitm = (tySequence_qwqHTkRvwhrRyENtudHQ7g*)0;
		nimln_(2185, "system.nim");
		i = ((NI) 0);
		{
			nimln_(2186, "system.nim");
			while (1) {
				NI T4_;
				NI TM_77ITQxrABVT9b2GcbWeV4SQ_2;
				NI TM_77ITQxrABVT9b2GcbWeV4SQ_3;
				if (!(i < seqsLen_0)) goto LA3;
				nimln_(2187, "system.nim");
				if ((NU)(i) >= (NU)(seqsLen_0)) raiseIndexError();
				seqitm = seqs[i];
				nimln_(41, "sequtils.nim");
				T4_ = (seqitm ? seqitm->Sup.len : 0);
				TM_77ITQxrABVT9b2GcbWeV4SQ_2 = addInt(L, T4_);
				L = (NI)(TM_77ITQxrABVT9b2GcbWeV4SQ_2);
				nimln_(2188, "system.nim");
				TM_77ITQxrABVT9b2GcbWeV4SQ_3 = addInt(i, ((NI) 1));
				i = (NI)(TM_77ITQxrABVT9b2GcbWeV4SQ_3);
			} LA3: ;
		}
	}
	nimln_(42, "sequtils.nim");
	result = (tySequence_qwqHTkRvwhrRyENtudHQ7g*) newSeq((&NTI_qwqHTkRvwhrRyENtudHQ7g_), ((NI)chckRange(L, ((NI) 0), ((NI) IL64(9223372036854775807)))));
	nimln_(43, "sequtils.nim");
	i_2 = ((NI) 0);
	{
		tySequence_qwqHTkRvwhrRyENtudHQ7g* s;
		NI i_3;
		s = (tySequence_qwqHTkRvwhrRyENtudHQ7g*)0;
		nimln_(2185, "system.nim");
		i_3 = ((NI) 0);
		{
			nimln_(2186, "system.nim");
			while (1) {
				NI TM_77ITQxrABVT9b2GcbWeV4SQ_7;
				if (!(i_3 < seqsLen_0)) goto LA7;
				nimln_(2187, "system.nim");
				if ((NU)(i_3) >= (NU)(seqsLen_0)) raiseIndexError();
				s = seqs[i_3];
				{
					NI itm;
					NI i_4;
					NI L_2;
					NI T9_;
					itm = (NI)0;
					nimln_(3805, "system.nim");
					i_4 = ((NI) 0);
					nimln_(3806, "system.nim");
					T9_ = (s ? s->Sup.len : 0);
					L_2 = T9_;
					{
						nimln_(3807, "system.nim");
						while (1) {
							NI TM_77ITQxrABVT9b2GcbWeV4SQ_4;
							NI TM_77ITQxrABVT9b2GcbWeV4SQ_5;
							if (!(i_4 < L_2)) goto LA11;
							nimln_(3808, "system.nim");
							if ((NU)(i_4) >= (NU)(s->Sup.len)) raiseIndexError();
							itm = s->data[i_4];
							if ((NU)(i_2) >= (NU)(result->Sup.len)) raiseIndexError();
							nimln_(46, "sequtils.nim");
							result->data[i_2] = itm;
							nimln_(47, "sequtils.nim");
							TM_77ITQxrABVT9b2GcbWeV4SQ_4 = addInt(i_2, ((NI) 1));
							i_2 = (NI)(TM_77ITQxrABVT9b2GcbWeV4SQ_4);
							nimln_(3809, "system.nim");
							TM_77ITQxrABVT9b2GcbWeV4SQ_5 = addInt(i_4, ((NI) 1));
							i_4 = (NI)(TM_77ITQxrABVT9b2GcbWeV4SQ_5);
							nimln_(3810, "system.nim");
							{
								NI T14_;
								T14_ = (s ? s->Sup.len : 0);
								if (!!((T14_ == L_2))) goto LA15_;
								failedAssertImpl_aDmpBTs9cPuXp0Mp9cfiNeyA(((NimStringDesc*) &TM_77ITQxrABVT9b2GcbWeV4SQ_6));
							}
							LA15_: ;
						} LA11: ;
					}
				}
				nimln_(2188, "system.nim");
				TM_77ITQxrABVT9b2GcbWeV4SQ_7 = addInt(i_3, ((NI) 1));
				i_3 = (NI)(TM_77ITQxrABVT9b2GcbWeV4SQ_7);
			} LA7: ;
		}
	}
	popFrame();
	return result;
}
NIM_EXTERNC N_NOINLINE(void, stdlib_sequtilsInit000)(void) {
	nimfr_("sequtils", "sequtils.nim");
	popFrame();
}

NIM_EXTERNC N_NOINLINE(void, stdlib_sequtilsDatInit000)(void) {
}

