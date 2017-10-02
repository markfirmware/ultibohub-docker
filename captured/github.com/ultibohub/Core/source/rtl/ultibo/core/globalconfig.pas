{
Ultibo Global Configuration Defaults.

Copyright (C) 2015 - SoftOz Pty Ltd.

Arch
====

 <All>

Boards
======

 <All>

Licence
=======

 LGPLv2.1 with static linking exception (See COPYING.modifiedLGPL.txt)
 
Credits
=======

 Information for this unit was obtained from:

 
References
==========


Global Configuration
====================


}

{--$mode delphi} {Default to Delphi compatible syntax} {Not compatible with external definitions below}
{$mode objfpc}
{$H+}            {Default to AnsiString}
{$inline on}     {Allow use of Inline procedures}

unit GlobalConfig;

interface

uses GlobalConst,GlobalTypes,GlobalStrings;

//To Do //LongWord values in here that refer to an address (eg MEMORY_BASE / IRQ_STACK_BASE) need to be made PtrUInt for 64 bit compatibility

//To Do //Look for:

//

{==============================================================================}
{Global definitions}
{$INCLUDE GlobalDefines.inc}

{==============================================================================}
{Compiler and RTL configuration}
var
 {Kernel Image sections}
 {Note: To access these from Pascal code use the address of the variable (eg @_bss_start). Empty record definition prevents access to contents}
 _text_start: record end; external name '_text_start';
 _etext: record end; external name '_etext';
 _data: record end; external name '_data';
 _edata: record end; external name '_edata';
 _bss_start: record end; external name '_bss_start';
 _bss_end: record end; external name '_bss_end';

var
 {Library Initialization and Finalization sections}
 {Note: To access these from Pascal code use the address of the variable (eg @__ctors_start). Empty record definition prevents access to contents}
 __preinit_array_start: record end; external name '__preinit_array_start';
 __preinit_array_end: record end; external name '__preinit_array_end';
 
 __init_array_start: record end; external name '__init_array_start';
 __init_array_end: record end; external name '__init_array_end';
 
 __fini_array_start: record end; external name '__fini_array_start';
 __fini_array_end: record end; external name '__fini_array_end';
 
 __ctors_start: record end; external name '__ctors_start';
 __ctors_end: record end; external name '__ctors_end';

 __dtors_start: record end; external name '__dtors_start';
 __dtors_end: record end; external name '__dtors_end';
 
{==============================================================================}
var
 {RTL Initial Heap allocation}
 RtlHeapAddr:record end; external name '__fpc_initialheap';
 RtlHeapSize:PtrInt; external name '__heapsize';

{==============================================================================}
var
 {RTL Error Handling}
 RtlErrorBase:Pointer; external name 'FPC_ERRORBASE';
 
{==============================================================================}
var 
 {RTL Initialization}
 RtlInitFinalTable:record end; external name 'INITFINAL';
 
{==============================================================================}
{Memory and Peripheral mapping configuration}
var
 {Physical to IO Address Mapping}
 IO_BASE:PtrUInt;                  {The base for conversion from a Physical Address to an IO Address and back (Where Applicable)}
 IO_ALIAS:PtrUInt;                 {The alias for conversion from a Physical Address to an IO Address and back (Where Applicable)}
 
 {Physical to Bus Address Mapping}
 BUS_ALIAS:PtrUInt;                {The mask for conversion from a Physical Address to a Bus Address and back (Where Applicable)}

{==============================================================================}
var
 {Secure Boot}
 SECURE_BOOT:LongBool;             {True if the boot process occurs in secure mode (Where Applicable)}
 
{==============================================================================}
var
 {Startup Handler Address}
 STARTUP_ADDRESS:LongWord;         {The physical address of the Startup Handler on Reset}
 
{==============================================================================}
var 
 {Memory Base Mapping} 
 MEMORY_BASE:PtrUInt;              {The base (Physical) address for useable board memory}
 MEMORY_SIZE:LongWord;             {The size of the useable board address space}
 
 MEMORY_PAGE_SIZE:LongWord;        {The size of a memory page}
 MEMORY_LARGEPAGE_SIZE:LongWord;   {The size of a large memory page}
 
{==============================================================================}
var 
 {Memory Sizes}
 MEMORY_IRQ_SIZE:LongWord;         {The size of the registered IRQ memory (Per CPU) (Must be a multiple of HEAP_REQUEST_ALIGNMENT size)}
 MEMORY_FIQ_SIZE:LongWord;         {The size of the registered FIQ memory (Per CPU) (Must be a multiple of HEAP_REQUEST_ALIGNMENT size)}
 MEMORY_LOCAL_SIZE:LongWord;       {The size of the registered local memory (Per CPU) (Must be a multiple of HEAP_REQUEST_ALIGNMENT size)}
 MEMORY_SHARED_SIZE:LongWord;      {The size of the registered shared memory (Must be a multiple of HEAP_REQUEST_ALIGNMENT size)}
 MEMORY_DEVICE_SIZE:LongWord;      {The size of the registered device memory (Must be a multiple of HEAP_REQUEST_ALIGNMENT size)}
 MEMORY_NOCACHE_SIZE:LongWord;     {The size of the registered non cacheable memory (Must be a multiple of HEAP_REQUEST_ALIGNMENT size)}
 MEMORY_NONSHARED_SIZE:LongWord;   {The size of the registered non shareable memory (Must be a multiple of HEAP_REQUEST_ALIGNMENT size)}
 
{==============================================================================}
var 
 {Peripheral Base Mapping}
 PERIPHERALS_BASE:PtrUInt;         {The base (Physical) address for accessing Peripherals}
 PERIPHERALS_SIZE:LongWord;        {The size of the Peripheral address space}

 {Local Peripheral Base Mapping}
 LOCAL_PERIPHERALS_BASE:PtrUInt;   {The base (Physical) address for accessing Local Peripherals (Peripherals local to each CPU)}
 LOCAL_PERIPHERALS_SIZE:LongWord;  {The size of the Local Peripheral address space}
 
{==============================================================================}
var
 {Page Table Base Mapping}
 PAGE_TABLE_BASE:PtrUInt;          {The base (Physical) address of the first level Page Table}
 PAGE_TABLE_SIZE:LongWord;         {The size of the first level Page Table address space}

 {Second Level Page Tables}
 PAGE_TABLES_ADDRESS:PtrUInt;      {The base (Physical) address of the second level Page Tables}
 PAGE_TABLES_LENGTH:LongWord;      {The size of the second level Page Table address space (Rounded to Page Size)}
 PAGE_TABLES_COUNT:LongWord;       {How many second level Page Tables allocated at this address}
 PAGE_TABLES_SHIFT:LongWord;       {The multiplier (left shift) to convert count to size (PAGE_TABLES_COUNT shl PAGE_TABLES_SHIFT = Actual Size)}
 
 PAGE_TABLES_NEXT:PtrUInt;         {The base (Physical) address of the next available second level Page Table}
 PAGE_TABLES_USED:LongWord;        {How many second level Page Tables are in use (During boot this will be set to the number required to cover the code and data plus initial stack, heap and overhead)}
 PAGE_TABLES_FREE:LongWord = 1024; {How many second level Page Tables are available (The initial value here will be added to the number calculated during boot to provide extras for page allocation)}
 
{==============================================================================}
var
 {Page Table Sizes}
 PAGE_MIN_SIZE:LongWord          = SIZE_4K;  {The minimum size of a memory page in the page tables (Default 4K)}
 PAGE_SMALL_SIZE:LongWord        = SIZE_4K;  {The size of a small memory page in the page tables (Default 4K)}
 PAGE_LARGE_SIZE:LongWord        = SIZE_64K; {The size of a large memory page in the page tables (Default 64K)}
 PAGE_SECTION_SIZE:LongWord      = SIZE_1M;  {The size of a memory section in the page tables (Default 1M)}
 PAGE_SUPERSECTION_SIZE:LongWord = SIZE_16M; {The size of a memory super section in the page tables (Default 16M)}
  
{==============================================================================}
var
 {Vector Table Base Mapping}
 VECTOR_TABLE_BASE:PtrUInt;          {The base (Physical) address of the Interrupt Vector Table}
 VECTOR_TABLE_SIZE:LongWord;         {The size of the Interrupt Vector Table address space}
 VECTOR_TABLE_COUNT:LongWord;        {The number of entries in the Interrupt Vector Table}
 
{==============================================================================}
{Machine and Board configuration}
var
 {Machine configuration}
 MACHINE_TYPE:LongWord;
 
{==============================================================================}
var
 {Board configuration}
 BOARD_TYPE:LongWord;
 
{==============================================================================}
{CPU / FPU / GPU configuration}
var
 {CPU configuration}
 CPU_ARCH:LongWord;                   {The current CPU architecture for this board}
 CPU_TYPE:LongWord;                   {The current CPU model for this board}
 CPU_COUNT:LongWord;                  {The current CPU count for this board}
 
 CPU_BOOT:LongWord;                   {Which CPU is used for the boot process}
 CPU_MASK:LongWord;                   {The mask of current CPUs for scheduling affinity}
 
 CPU_MEMORY_BASE:PtrUInt;             {The base (Physical) address for CPU memory}
 CPU_MEMORY_SIZE:LongWord;            {The size of the CPU address space}
 
 CPU_MEMORY_RESTRICTED:LongBool;      {Any areas of CPU address space with no physical memory are marked as no access}
 
{==============================================================================}
var
 {FPU configuration}
 FPU_TYPE:LongWord;                   {The current FPU type for this board}

{==============================================================================}
var
 {GPU configuration}
 GPU_TYPE:LongWord;                   {The current GPU type for this board}

 GPU_MEMORY_BASE:PtrUInt;             {The base (Physical) address for GPU memory}
 GPU_MEMORY_SIZE:LongWord;            {The size of the GPU address space}

 GPU_MEMORY_CACHED:LongBool;          {The GPU memory is cached when accessed by the CPU}
 
{==============================================================================}
var
 {IRQ/FIQ/SWI configuration}
 IRQ_COUNT:LongWord;                  {The total number of IRQs supported for this board}
 FIQ_COUNT:LongWord;                  {The total number of FIQs supported for this board}

 IRQ_START:LongWord = 0;              {The starting number for system wide IRQs/FIQs (Where Applicable)(Normally zero)}

 IRQ_ROUTING:LongWord = CPU_ID_ALL;   {Which CPU to route system wide IRQs to (Where Applicable)(CPU_ID_ALL if system supports routing individual IRQs to any CPU)}
 FIQ_ROUTING:LongWord = CPU_ID_ALL;   {Which CPU to route system wide FIQs to (Where Applicable)(CPU_ID_ALL if system supports routing individual FIQs to any CPU)}
 
 IRQ_LOCAL_COUNT:LongWord;            {The number of local (Per CPU) IRQs supported for this board (Where Applicable)}
 FIQ_LOCAL_COUNT:LongWord;            {The number of local (Per CPU) FIQs supported for this board (Where Applicable)}
 
 IRQ_LOCAL_START:LongWord;            {The starting number for local (Per CPU) IRQs/FIQs (Where Applicable)}
 
 SWI_COUNT:LongWord;                  {The total number of SWIs supported for this board (Where Applicable)}
 
{==============================================================================}
{Interrupt and Exception configuration}
var
 IRQ_ENABLED:LongBool;                      {The current CPU supports Interrupt Requests (IRQ)}
 FIQ_ENABLED:LongBool;                      {The current CPU supports Fast Interrupt Requests (FIQ)}
 SWI_ENABLED:LongBool;                      {The current CPU supports Software Interrupt Handlers (SWI)}
 ABORT_ENABLED:LongBool;                    {The current CPU supports Data and/or Prefetch Abort Handlers}
 UNDEFINED_ENABLED:LongBool;                {The current CPU supports Undefined Instruction Handlers}
 
 IRQ_STACK_ENABLED:LongBool;                {The current CPU uses an Interrupt Request Stack (IRQ)}
 FIQ_STACK_ENABLED:LongBool;                {The current CPU uses a Fast Interrupt Request Stack (FIQ)}
 SWI_STACK_ENABLED:LongBool;                {The current CPU uses a Software Interrupt Stack (SWI)}
 ABORT_STACK_ENABLED:LongBool;              {The current CPU uses a Data and/or Prefetch Abort Stack}
 UNDEFINED_STACK_ENABLED:LongBool;          {The current CPU uses an Undefined Instruction Stack}
 
{==============================================================================}
 {Clock and Timer configuration} 
var
 {Clock configuration}
 CLOCK_FREQUENCY:LongWord;                 {The frequency in Hz of the system timer used to provide the system clock (Clock cycles per second)}
 CLOCK_TICKS_PER_SECOND:LongWord = 1000;   {How many clock interrupts to schedule per second (1000 equals 1 per millisecond)}
 CLOCK_TICKS_PER_MILLISECOND:LongWord = 1; {How many clock interrupts occur every millisecond (Normally 1 if CLOCK_TICKS_PER_SECOND is 1000)}
 CLOCK_CYCLES_PER_TICK:LongWord;           {How many clock cycles between clock interrupts (Normally CLOCK_FREQUENCY div CLOCK_TICKS_PER_SECOND)}
 CLOCK_CYCLES_PER_MILLISECOND:LongWord;    {How many clock cycles to a millisecond (Normally CLOCK_FREQUENCY div MILLISECONDS_PER_SECOND)}
 CLOCK_CYCLES_PER_MICROSECOND:LongWord;    {How many clock cycles to a microsecond (Normally CLOCK_FREQUENCY div MICROSECONDS_PER_SECOND)}
 CLOCK_CYCLES_PER_NANOSECOND:LongWord;     {How many clock cycles to a nanosecond (Normally CLOCK_FREQUENCY div NANOSECONDS_PER_SECOND)}
 CLOCK_CYCLES_TOLERANCE:LongWord;          {How many clock cycles tolerance when scheduling the next clock interrupt (Normally CLOCK_CYCLES_PER_TICK div 10)} 
 
 CLOCK_FIQ_ENABLED:LongBool;               {The Clock uses Fast Interrupt Requests (FIQ) instead of IRQ}
 
 TIME_TICKS_PER_CLOCK_INTERRUPT:LongWord;  {How many 100 nanosecond time ticks per clock interrupt}
 
{==============================================================================}
var
 {Timer configuration}
 TIMER_THREAD_COUNT:LongWord = 4;              {How many timer threads to create}
 TIMER_PRIORITY_THREAD_COUNT:LongWord = 1;     {How many priority timer threads to create}
 TIMER_MESSAGESLOT_MAXIMUM:LongWord = SIZE_2K; {Maximum number of messages for the timer messageslot}
 
{==============================================================================}
var
 {Worker configuration}
 WORKER_THREAD_COUNT:LongWord = 8;              {How many worker threads to create}
 WORKER_PRIORITY_THREAD_COUNT:LongWord = 2;     {How many priority worker threads to create}
 WORKER_MESSAGESLOT_MAXIMUM:LongWord = SIZE_2K; {Maximum number of messages for the worker messageslot}
 
{==============================================================================}
{Spin, Mutex, Semaphore, Critical Section, Event and Buffer configuration}
var
 {Spin defaults}
 SPIN_SHARED_MEMORY:LongBool;             {Spin locks are allocated from Shared memory regions if True}
 
 {Mutex defaults}
 MUTEX_SHARED_MEMORY:LongBool;            {Mutexs are allocated from Shared memory regions if True}
 MUTEX_DEFAULT_SPINCOUNT:LongWord = 0;    {Default number of times a mutex will spin before yielding (Overidden to 0 if CPU count equals 1)}
 
 {Semaphore defaults}
 SEMAPHORE_SHARED_MEMORY:LongBool;                   {Semaphores are allocated from Shared memory regions if True}
 SEMAPHORE_DEFAULT_MAXIMUM:LongWord = $FFFFFFFF;     {Default maximum count for a seamphore}

 {Synchronizer defaults}
 SYNCHRONIZER_SHARED_MEMORY:LongBool;                {Synchronizers are allocated from Shared memory regions if True}

 {Condition defaults}
 CONDITION_SHARED_MEMORY:LongBool;                   {Condition variables are allocated from Shared memory regions if True}

 {Completion defaults}
 COMPLETION_SHARED_MEMORY:LongBool;                  {Completion variables are allocated from Shared memory regions if True}
 
 {Critical Section defaults}
 CRITICAL_SECTION_SHARED_MEMORY:LongBool;            {Critical Sections are allocated from Shared memory regions if True}
 CRITICAL_SECTION_DEFAULT_SPINCOUNT:LongWord = 0;    {Default number of times a critical section will spin before waiting (Overidden to 0 if CPU count equals 1)}
 
 {Messageslot defaults}
 MESSAGESLOT_SHARED_MEMORY:LongBool;             {Messageslots are allocated from Shared memory regions if True}
 MESSAGESLOT_DEFAULT_MAXIMUM:LongWord = SIZE_1K; {Default maximum number of messages that can be stored in a messageslot}
 
 {Mailslot defaults}
 MAILSLOT_SHARED_MEMORY:LongBool;             {Mailslots are allocated from Shared memory regions if True}

 {Buffer defaults}
 BUFFER_SHARED_MEMORY:LongBool;               {Buffers are allocated from Shared memory regions if True}
 BUFFER_MIN_SIZE:LongWord = SizeOf(Pointer);  {Minimum size of an item in a buffer}
 BUFFER_MAX_SIZE:LongWord = SIZE_4K;          {Maximum size of an item in a buffer}
 BUFFER_MAX_COUNT:LongWord = SIZE_8K;         {Maximum number of items in a buffer}
 
 {Event defaults}
 EVENT_SHARED_MEMORY:LongBool;                {Events are allocated from Shared memory regions if True}
 
 {Handle defaults}
 HANDLE_SHARED_MEMORY:LongBool;               {Handles are allocated from Shared memory regions if True}
 
{==============================================================================}
{Heap, Stack, and Thread configuration} 
var
 {Heap Alignment}
 HEAP_MIN_ALIGNMENT:LongWord = SizeOf(Pointer); {The default alignment for the Heap Manager (Set by board specific initialization if not default)(Must be a power of 2)}
 HEAP_REQUEST_ALIGNMENT:LongWord = SIZE_4K;     {The required alignment for Heap Manager requests (eg RequestSharedHeapBlock etc) (Set by board specific initialization if not default)(Must be a power of 2)}
 
 {Heap Behaviour}
 HEAP_NORMAL_SHARED:LongBool;                   {If True then Normal memory is considered Shared memory by the Heap Manager (Default False)}
 HEAP_NORMAL_LOCAL:LongBool;                    {If True then Normal memory is considered Local memory by the Heap Manager (Default False)}
 HEAP_NORMAL_CODE:LongBool;                     {If True then Normal memory is considered Code memory by the Heap Manager (Default False)}
 HEAP_NORMAL_DEVICE:LongBool;                   {If True then Normal memory is considered Device memory by the Heap Manager (Default False)}
 HEAP_NORMAL_NOCACHE:LongBool;                  {If True then Normal memory is considered Non Cached memory by the Heap Manager (Default False)}
 HEAP_NORMAL_NONSHARED:LongBool;                {If True then Normal memory is considered Non Shared memory by the Heap Manager (Default False)}
 
 HEAP_LOCAL_CACHE_COHERENT:LongBool;            {If True then Local memory is considered cache coherent (Default False)}
 
 HEAP_IRQ_CACHE_COHERENT:LongBool;              {If True then IRQ memory is considered cache coherent (Default False)}
 HEAP_FIQ_CACHE_COHERENT:LongBool;              {If True then FIQ memory is considered cache coherent (Default False)}
 
 {Heap Locking}
 HEAP_LOCK_SPIN:LongBool;                       {If True then Heap lock uses Spin instead of Mutex (Default False)}
 
var
 {Stack Alignment}
 STACK_MIN_ALIGNMENT:LongWord = SizeOf(Pointer); {The default alignment for Thread stacks (Set by board specific initialization if not default)(Must be a power of 2)}

var
 {Threadvar Alignment}
 THREADVAR_MIN_ALIGNMENT:LongWord = SizeOf(Pointer); {The default alignment for Thread Vars (Set by board specific initialization if not default)}
 
var
 {Initial Heap allocation (Used prior to Memory Manager initialization)}
 INITIAL_HEAP_SIZE:LongWord = SIZE_64K; {The size of the initial heap allocation (Set by board specific initialization if not default)}
 INITIAL_HEAP_BASE:PtrUInt;             {The base address of the initial heap allocation (Set by StartupHandler)}

var
 {Initial Thread defaults (The first created thread for the primary CPU which becomes either IRQ_THREAD_HANDLE[CPU_ID_0] or FIQ_THREAD_HANDLE[CPU_ID_0])}
 INITIAL_TLS_SIZE:LongWord   = SIZE_16K;    {Default TLS (Thread Var) block size for the Initial Thread (Calculated TLS size is used for all other threads)}
 INITIAL_STACK_SIZE:LongWord = SIZE_32K;    {Default stack size for the Initial Thread}
 INITIAL_STACK_BASE:PtrUInt;                {The base address (Top) of the stack for the Initial Thread (Set by StartupHandler)}

var
 {Boot Thread defaults (The first created thread for each secondary CPU which becomes either IRQ_THREAD_HANDLE[CPUID] or FIQ_THREAD_HANDLE[CPUID])} 
 BOOT_STACK_SIZE:LongWord = SIZE_32K;             {Default stack size for the Boot Threads} 
 BOOT_STACK_BASE:array of PtrUInt;                {The base address (Top) of the stack for the Boot Threads (One per CPU, allocated by threads initialization)}
 BOOT_THREAD_HANDLE:array of TThreadHandle;       {Handles of the Boot Threads (One per CPU, allocated by threads initialization)}
 
var
 {Idle Thread defaults}
 IDLE_STACK_SIZE:LongWord = SIZE_32K;             {Default stack size for Idle Threads}
 IDLE_THREAD_HANDLE:array of TThreadHandle;       {Handles of the Idle Threads (One per CPU, allocated by threads initialization)}
 
var
 {IRQ Thread defaults}
 IRQ_STACK_SIZE:LongWord = SIZE_32K;              {Default stack size for IRQ Threads}
 IRQ_STACK_BASE:array of PtrUInt;                 {The base address (Top) of the stack for the IRQ Threads (One per CPU, allocated by threads initialization)}
 IRQ_THREAD_HANDLE:array of TThreadHandle;        {Handles of the IRQ Threads (One per CPU, allocated by threads initialization)}
 
var
 {FIQ Thread defaults}
 FIQ_STACK_SIZE:LongWord = SIZE_32K;              {Default stack size for FIQ Threads}
 FIQ_STACK_BASE:array of PtrUInt;                 {The base address (Top) of the stack for the FIQ Threads (One per CPU, allocated by threads initialization)}
 FIQ_THREAD_HANDLE:array of TThreadHandle;        {Handles of the FIQ Threads (One per CPU, allocated by threads initialization)}

var
 {SWI Thread defaults}
 SWI_STACK_SIZE:LongWord = SIZE_32K;              {Default stack size for Software Interrupt Handlers (SWI)} 
 SWI_STACK_BASE:array of PtrUInt;                 {The base address (Top) of the stack for the Software Interrupt Handlers (One per CPU, allocated by threads initialization)}
 SWI_THREAD_HANDLE:array of TThreadHandle;        {Handles of the Software Interrupt Handler (SWI) Threads (One per CPU, allocated by threads initialization)}
 
var
 {Thread defaults} 
 THREAD_SHARED_MEMORY:LongBool;                   {Threads are allocated from Shared memory regions if True}
 
 THREAD_STACK_DEFAULT_SIZE:LongWord = SIZE_256K;  {Default stack size for all threads (Unless specified during creation)}
 THREAD_STACK_MINIMUM_SIZE:LongWord = SIZE_4K;    {Minimum thread stack size}
 THREAD_STACK_MAXIMUM_SIZE:LongWord = SIZE_4M;    {Maximum thread stack size}
 THREAD_STACK_GUARD_ENABLED:LongBool = True;      {If True then each thread stack includes a guard page to detect stack overflows}
 
 THREAD_NAME_DEFAULT:String;                      {The default name for new threads} 
 THREAD_MESSAGES_MAXIMUM:LongWord = SIZE_256;     {Maximum number of messages that can be stored in a thread message list}
 
var
 {ABORT Stack defaults}
 ABORT_STACK_SIZE:LongWord = SIZE_4K;             {Default stack size for Data and/or Prefetch Abort Handlers} 
 ABORT_STACK_BASE:array of PtrUInt;               {The base address (Top) of the stack for the Data and/or Prefetch Abort Handlers (One per CPU, allocated by threads initialization)}
 
var
 {UNDEFINED Stack defaults}
 UNDEFINED_STACK_SIZE:LongWord = SIZE_4K;         {Default stack size for Undefined Instruction Handlers} 
 UNDEFINED_STACK_BASE:array of PtrUInt;           {The base address (Top) of the stack for the Undefined Instruction Handlers (One per CPU, allocated by threads initialization)}
 
{==============================================================================}
{Scheduler configuration} 
var
 {Scheduler defaults}
 SCHEDULER_INTERRUPTS_PER_SECOND:LongWord = 1000;   {How many scheduler interrupts to schedule per second (1000 equals 1 per millisecond)}
 SCHEDULER_INTERRUPTS_PER_MILLISECOND:LongWord = 1; {How many scheduler interrupts occur every millisecond (Normally 1 if SCHEDULER_INTERRUPTS_PER_SECOND is 1000)}
 SCHEDULER_CLOCKS_PER_INTERRUPT:LongWord;           {How many clock cycles between scheduler interrupts (Normally CLOCK_FREQUENCY div SCHEDULER_INTERRUPTS_PER_SECOND)}
 SCHEDULER_CLOCKS_TOLERANCE:LongWord;               {How many clock cycles tolerance when scheduling the next scheduler interrupt (Normally SCHEDULER_CLOCKS_PER_INTERRUPT div 10)}
 
 SCHEDULER_CPU_COUNT:LongWord;                      {The current CPU count used by the scheduler (Requested from CPUGetCount) (Set by threads initialization)}
 SCHEDULER_CPU_MASK:LongWord;                       {The current CPU mask used by the scheduler (Requested from CPUGetMask) (Set by threads initialization)}
 SCHEDULER_CPU_BOOT:LongWord;                       {The current boot CPU id used by the scheduler (Requested from CPUGetBoot) (Set by threads initialization)}
 
 SCHEDULER_THREAD_QUANTUM:LongWord = 6;             {How many scheduler interrupts for the base thread quantum (Actual quantum is adjusted by priority)}
 SCHEDULER_PRIORITY_QUANTUM:array of LongWord;      {How many scheduler interrupts to adjust the base thread quantum for each priority level (One per priority level, allocated by threads initialization)}
 SCHEDULER_MIGRATION_QUANTUM:LongWord = 100;        {How many scheduler thread switches between thread migration checks}
 SCHEDULER_STARVATION_QUANTUM:LongWord = 5;         {How many scheduler thread switches between thread starvation checks}
 SCHEDULER_TERMINATION_INITIAL:LongWord = 100;      {How many scheduler interrupts to wait between thread termination and stack release}
 SCHEDULER_TERMINATION_QUANTUM:LongWord = 30000;    {How many scheduler interrupts to wait between thread termination and thread destruction}

 SCHEDULER_MIGRATION_OFFSET:LongWord = 5;           {The minimum offset between CPU thread counts for a migration to occur}
 
 SCHEDULER_PRIORITY_MASK:array of LongWord;         {Mask value of each thread priority level used for determining highest priority thread (One per priority level, allocated by threads initialization)}
 
 SCHEDULER_FIQ_ENABLED:LongBool;                    {The Scheduler uses Fast Interrupt Requests (FIQ) instead of IRQ}
 SCHEDULER_SWI_ENABLED:LongBool;                    {The Scheduler uses Software Interrupts for rescheduling instead of direct context switch}
 
 SCHEDULER_SECONDARY_WAIT:LongBool = False;         {If True all secondary CPUs wait until initialization is completed}
 SCHEDULER_SECONDARY_DISABLED:LongBool;             {If True all secondary CPUs will be put to sleep during boot}
 
 SCHEDULER_IDLE_WAIT:LongBool;                      {If True then the idle loop will wait in low power state on each iteration (May affect utilization calculation)}
 SCHEDULER_IDLE_OFFSET:LongWord;                    {Idle loop delay per iteration (Milliseconds)}
 SCHEDULER_IDLE_PER_SECOND:LongWord;                {How many idle loops complete in one second when no other tasks are running (Set by threads initialization)}
 
 TIME_TICKS_PER_SCHEDULER_INTERRUPT:LongWord;       {How many 100 nanosecond time ticks per scheduler interrupt}
 
{==============================================================================}
{Peripheral configuration (Set by PeripheralInit)}
var
 {Peripheral addresses}
 INTERRUPT_REGS_BASE:LongWord;    {The base address of the Interrupt Controller registers (If Applicable)}
 SYSTEMTIMER_REGS_BASE:LongWord;  {The base address of the System Timer registers (If Applicable)}
 TIMER_REGS_BASE:LongWord;        {The base address of the Timer registers (If Applicable)}
 GPIO_REGS_BASE:LongWord;         {The base address of the GPIO registers (If Applicable)}
 UART_REGS_BASE:LongWord;         {The base address of the primary UART registers (If Applicable)}
 SPI_REGS_BASE:LongWord;          {The base address of the primary SPI registers (If Applicable)}
 I2C_REGS_BASE:LongWord;          {The base address of the primary I2C registers (If Applicable)}
 I2S_REGS_BASE:LongWord;          {The base address of the primary I2S registers (If Applicable)}
 PWM_REGS_BASE:LongWord;          {The base address of the primary PWM registers (If Applicable)}
 
{==============================================================================}
{Interrupt configuration (Set by PeripheralInit)}
//var
 {Interrupt assignments}
 //To Do //IRQ numbers for generic usage ? (Various devices - Set by PeripheralInit)
 
{==============================================================================}
{LED configuration (Set by specific PlatformInit)}
var
 {Power LED}
 POWER_LED_PIN:LongWord = GPIO_PIN_UNKNOWN;           {The GPIO Pin for the Power LED (Where Applicable)}
 POWER_LED_PULL:LongWord = GPIO_PULL_UNKNOWN;         {The GPIO Pull Select for the Power LED (Where Applicable)}
 POWER_LED_FUNCTION:LongWord = GPIO_FUNCTION_UNKNOWN; {The GPIO Function Select for the Power LED (Where Applicable)}
 POWER_LED_ACTIVE_LOW:LongBool;                       {If True the Power LED is Active Low (Clear Pin to Turn On) (Where Applicable)}
 
var
 {Activity LED} 
 ACTIVITY_LED_PIN:LongWord = GPIO_PIN_UNKNOWN;           {The GPIO Pin for the Activity LED (Where Applicable)}  
 ACTIVITY_LED_PULL:LongWord = GPIO_PULL_UNKNOWN;         {The GPIO Pull Select for the Activity LED (Where Applicable)}
 ACTIVITY_LED_FUNCTION:LongWord = GPIO_FUNCTION_UNKNOWN; {The GPIO Function Select for the Activity LED (Where Applicable)}
 ACTIVITY_LED_ACTIVE_LOW:LongBool;                       {If True the Activity LED is Active Low (Clear Pin to Turn On) (Where Applicable)}
 
{==============================================================================}
{Console and FrameBuffer configuration}
var
 {Console}
 CONSOLE_DEFAULT_FORECOLOR:LongWord;             {The default foreground color for the console}
 CONSOLE_DEFAULT_BACKCOLOR:LongWord;             {The default background color for the console}
 
 CONSOLE_DEFAULT_BORDERWIDTH:LongWord;           {The default border width for the console}
 CONSOLE_DEFAULT_BORDERCOLOR:LongWord;           {The default border color for the console}
 
 CONSOLE_DEFAULT_FONT:THandle = INVALID_HANDLE_VALUE; {The default Font for the console}
 CONSOLE_DEFAULT_FONT_NAME:String;               {The default Font name for the console}

 CONSOLE_LINE_WRAP:LongBool = True;              {If True then wrap long lines to the next line when writing to the console (Sets CONSOLE_FLAG_LINE_WRAP on device / WINDOW_FLAG_LINE_WRAP on windows)}
 CONSOLE_AUTO_SCROLL:LongBool = True;            {If True then automatically scroll up on reaching the last line of the console (Sets CONSOLE_FLAG_AUTO_SCROLL on device / WINDOW_FLAG_AUTO_SCROLL on windows)}
 
 CONSOLE_DMA_BOX:LongBool = True;                {If True then use DMA (If available) to draw console window boxes (Sets CONSOLE_FLAG_DMA_BOX on device)}
 CONSOLE_DMA_TEXT:LongBool = False;              {If True then use DMA (If available) to draw console window text (Sets CONSOLE_FLAG_DMA_TEXT on device)}
 CONSOLE_DMA_LINE:LongBool = True;               {If True then use DMA (If available) to draw console window lines (Sets CONSOLE_FLAG_DMA_LINE on device)}
 CONSOLE_DMA_FILL:LongBool = True;               {If True then use DMA (If available) to fill console windows (Sets CONSOLE_FLAG_DMA_FILL on device)}
 CONSOLE_DMA_CLEAR:LongBool = True;              {If True then use DMA (If available) to clear console windows (Sets CONSOLE_FLAG_DMA_CLEAR on device)}
 CONSOLE_DMA_SCROLL:LongBool = True;             {If True then use DMA (If available) to scroll console windows (Sets CONSOLE_FLAG_DMA_SCROLL on device)}
 
 CONSOLE_REGISTER_LOGGING:LongBool = False;      {If True then register any Console device as a Logging device (Only if Console unit included)}
 CONSOLE_LOGGING_DEFAULT:LongBool = False;       {If True then a Console device can be the default Logging device}
 CONSOLE_LOGGING_POSITION:LongWord = CONSOLE_POSITION_RIGHT; {The default Console Window position for the console Logging device}
 CONSOLE_LOGGING_DEVICE:String;                  {The console device Name (or Desription) to create the Logging window on, if blank create on default device}
 
 CONSOLE_CRT_POSITION:LongWord = CONSOLE_POSITION_FULL; {The default Console Window position for the CRT unit (Only if CRT unit included)}
 
 CONSOLE_VIDEO_POSITION:LongWord = CONSOLE_POSITION_FULL; {The default Console Window position for the ConsoleVideo unit (Only if ConsoleVideo unit included)}
 CONSOLE_VIDEO_DEVICE:String;                    {The console device Name (or Description) to create the ConsoleVideo window on, if blank create on default device}
 CONSOLE_VIDEO_WINDOW:THandle = INVALID_HANDLE_VALUE; {The console window used or created by the ConsoleVideo unit}
 CONSOLE_VIDEO_FONT:String;                      {The font name to use for the ConsoleVideo window, if blank use the default font (Default8x16)}
 
var
 {Window}
 WINDOW_DEFAULT_FORECOLOR:LongWord;              {The default foreground color for console windows}
 WINDOW_DEFAULT_BACKCOLOR:LongWord;              {The default background color for console windows}
 
 WINDOW_DEFAULT_BORDERWIDTH:LongWord;            {The default border width for console windows}
 WINDOW_DEFAULT_BORDERCOLOR:LongWord;            {The default border color for console windows}
 
 WINDOW_DEFAULT_FONT:THandle = INVALID_HANDLE_VALUE; {The default Font for console windows}
 WINDOW_DEFAULT_FONT_NAME:String;                {The default Font name for console windows}
 
var
 {Framebuffer Console}
 FRAMEBUFFER_CONSOLE_AUTOCREATE:LongBool = True;       {If True then auto create a console on any framebuffer device (Only if Console unit included)}
 
 FRAMEBUFFER_CONSOLE_DEFAULT_DESKTOPOFFSET:LongWord;   {The default desktop offset for the framebuffer console}
 FRAMEBUFFER_CONSOLE_DEFAULT_DESKTOPCOLOR:LongWord;    {The default desktop color for the framebuffer console}
 
var
 {Framebuffer} 
 FRAMEBUFFER_DEFAULT_DEPTH:LongWord = FRAMEBUFFER_DEPTH_32;    {The default (Detected / Configured) Framebuffer depth in bits per pixel}
 FRAMEBUFFER_DEFAULT_ORDER:LongWord = FRAMEBUFFER_ORDER_RGB;   {The default (Detected / Configured) Framebuffer pixel order}
 FRAMEBUFFER_DEFAULT_MODE:LongWord = FRAMEBUFFER_MODE_ENABLED; {The default (Detected / Configured) Framebuffer alpha mode}
 FRAMEBUFFER_DEFAULT_WIDTH:LongWord;                           {The default (Detected / Configured) Framebuffer width in pixels}
 FRAMEBUFFER_DEFAULT_HEIGHT:LongWord;                          {The default (Detected / Configured) Framebuffer height in pixels}
 FRAMEBUFFER_DEFAULT_OFFSET_X:LongWord;                        {The default (Configured) Framebuffer X offset in pixels}
 FRAMEBUFFER_DEFAULT_OFFSET_Y:LongWord;                        {The default (Configured) Framebuffer Y offset in pixels}
 FRAMEBUFFER_DEFAULT_OVERSCAN_TOP:LongWord;                    {The default (Detected / Configured) Framebuffer Top overscan in pixels}
 FRAMEBUFFER_DEFAULT_OVERSCAN_BOTTOM:LongWord;                 {The default (Detected / Configured) Framebuffer Bottom overscan in pixels}
 FRAMEBUFFER_DEFAULT_OVERSCAN_LEFT:LongWord;                   {The default (Detected / Configured) Framebuffer Left overscan in pixels}
 FRAMEBUFFER_DEFAULT_OVERSCAN_RIGHT:LongWord;                  {The default (Detected / Configured) Framebuffer Right overscan in pixels}
 FRAMEBUFFER_DEFAULT_ROTATION:LongWord = FRAMEBUFFER_ROTATION_0; {The default (Detected / Configured) Framebuffer rotation on degress (Where Applicable)}
 
{==============================================================================}
{Command Line and Environment configuration}
var
 {Command Line}
 KERNEL_NAME:PChar;                           {The name of the Kernel image (Returned by ParamStr(0) or argv[0])}
 KERNEL_CONFIG:PChar;                         {The name of the Kernel configuration file (Where Applicable)}
 KERNEL_COMMAND:PChar;                        {The name of the Kernel command line file (Where Applicable)}
 
 {Environment}
 ENVIRONMENT_STRING_COUNT:LongWord = SIZE_64; {How many strings are allocated in the environment block (for Get/SetEnvironmentVariable)}
 
{==============================================================================}
{Timezone configuration}
var
 TIMEZONE_TIME_OFFSET:LongInt;      {The current time offset between UTC and Local time (Minutes)}
 TIMEZONE_TIME_ADJUST:LongInt;      {The current time offset between Local and Adjusted time (Minutes)}
 
 TIMEZONE_UPDATE_LAST:Int64;        {The clock time of the last timezone update check}
 TIMEZONE_UPDATE_CURRENT:LongBool;  {If true then a timezone update check is in progress}
 
 TIMEZONE_DEFAULT_NAME:String;      {The name of the default timezone}
 
{==============================================================================}
{DMA configuration}
var
 {DMA defaults}
 DMA_ALIGNMENT:LongWord;            {The default alignment for DMA memory allocations}
 DMA_MULTIPLIER:LongWord;           {The default multiplier for DMA memory allocations}
 DMA_SHARED_MEMORY:LongBool;        {DMA control blocks and DMA buffers are allocated from Shared memory regions if True}
 DMA_NOCACHE_MEMORY:LongBool;       {DMA control blocks and DMA buffers are allocated from Non Cached memory regions if True}
 DMA_BUS_ADDRESSES:LongBool;        {DMA control blocks and DMA buffers are referenced by Bus addresses if True}
 DMA_CACHE_COHERENT:LongBool;       {DMA control blocks and DMA buffers are considered cache coherent if True}
 
{==============================================================================}
{Device configuration}
var
 {Device defaults}
 DEVICE_SHARED_MEMORY:LongBool;                {Devices are allocated from Shared memory regions if True}

 DEVICE_REGISTER_CLOCK:LongBool = False;       {If True then register the default clock device handlers (Default False)}
 DEVICE_REGISTER_TIMER:LongBool = True;        {If True then register the default timer device handlers}
 DEVICE_REGISTER_RANDOM:LongBool = True;       {If True then register the default random device handlers}
 DEVICE_REGISTER_MAILBOX:LongBool = True;      {If True then register the default mailbox device handlers}
 DEVICE_REGISTER_WATCHDOG:LongBool = True;     {If True then register the default watchdog device handlers} 
 
{==============================================================================}
{Driver configuration}
var
 {Driver defaults}
 DRIVER_SHARED_MEMORY:LongBool;     {Drivers are allocated from Shared memory regions if True}

{==============================================================================}
{Host configuration}
var
 {Host defaults}
 HOST_SHARED_MEMORY:LongBool;       {Hosts are allocated from Shared memory regions if True}
 
{==============================================================================}
{Serial configuration}
var
 SERIAL_REGISTER_LOGGING:LongBool = False;      {If True then register any Serial device as a Logging device (Only if Serial unit included)}
 SERIAL_LOGGING_DEFAULT:LongBool = False;       {If True then a Serial device can be the default Logging device}
 SERIAL_LOGGING_PARAMETERS:String = '0,N,8,1';  {The default serial settings for the serial logging device (BaudRate,Parity,DataBits,StopBits)(BaudRate 0 equals use default rate)}
 
{==============================================================================}
{Logging configuration}
var
 {Logging defaults}
 LOGGING_DIRECT_ENABLE:LongBool;                 {If True then logging output is written directly and not scheduled via the logging thread}
 LOGGING_INCLUDE_COUNTER:LongBool = True;        {If True then logging output includes an incrementing counter to detect missed entries}
 LOGGING_INCLUDE_DATETIME:LongBool;              {If True then logging output includes the current date and time for each entry}
 LOGGING_INCLUDE_TICKCOUNT:LongBool;             {If True then logging output includes the 64-bit tick count value for each entry}
 
 LOGGING_MESSAGESLOT_MAXIMUM:LongWord = SIZE_8K; {Maximum number of messages for the logging messageslot}

{==============================================================================}
{Syscalls configuration}
var
 SYSCALLS_HEAP_BASE:PtrUInt = $C0000000;         {The starting address for the dynamic C library heap space (Only if Syscalls unit included)(0 equals use static heap space only)}
 SYSCALLS_HEAP_MIN:LongWord = SIZE_2M;           {The minimum size of the dynamic C library heap space (Only if Syscalls unit included)(Or the total size if using static heap space)}
 SYSCALLS_HEAP_MAX:LongWord = SIZE_1G;           {The maximum size of the dynamic C library heap space (Only if Syscalls unit included)(Ignored if using static heap space only)}
 SYSCALLS_HEAP_BLOCKSIZE:LongWord = SIZE_1M;     {The block size to request from the heap manager on each expansion of the dynamic C library heap space (Only if Syscalls unit included)}
 
{==============================================================================}
{Generic Peripheral configuration (Set by PeripheralInit)}
var
 {GPIO}
 GPIO_PIN_COUNT:LongWord;              {The number of GPIO pins available on this board}
 
 {Virtual GPIO}
 VIRTUAL_GPIO_PIN_COUNT:LongWord;      {The number of Virtual GPIO pins available on this board}
 
 {Keyboard}
 KEYBOARD_NUM_LOCK_DEFAULT:LongBool = True;     {If True then set Num Lock to On by default for all keyboards (Default: True)}
 KEYBOARD_CAPS_LOCK_DEFAULT:LongBool = False;   {If True then set Caps Lock to On by default for all keyboards}
 KEYBOARD_SCROLL_LOCK_DEFAULT:LongBool = False; {If True then set Scroll Lock to On by default for all keyboards}
 
 KEYBOARD_CTRL_ALT_IS_ALTGR:LongBool = False;      {If True then pressing Ctrl+Alt acts as the AltGr key}
 KEYBOARD_SHIFT_IS_CAPS_LOCK_OFF:LongBool = False; {If True then pressing Shift turns Off Caps Lock}
 
 {Mouse}
 MOUSE_SWAP_BUTTONS_DEFAULT:LongBool = False;   {If True then set Swap Buttons (Left <-> Right) to On by default for all mice}
 
 {Touch}
 TOUCH_MOUSE_DATA_DEFAULT:LongBool = True; {If True then set all touch devices to add mouse data events for compatibility (Default: True)}
 
 {USB}
 USB_AUTOSTART:LongBool = True;        {If True then auto start the USB subsystem on boot (Only if USB unit included)}
 USB_ASYNCSTART:LongBool = True;       {If True then auto start asynchronously using a worker thread instead of the main thread}
 
 USB_DMA_ALIGNMENT:LongWord;           {The default alignment for USB DMA memory allocations}  
 USB_DMA_MULTIPLIER:LongWord;          {The default multiplier for USB DMA memory allocations}  
 USB_DMA_SHARED_MEMORY:LongBool;       {USB DMA buffers are allocated from Shared memory regions if True}
 USB_DMA_NOCACHE_MEMORY:LongBool;      {USB DMA buffers are allocated from Non Cached memory regions if True}
 USB_DMA_BUS_ADDRESSES:LongBool;       {USB DMA buffers are referenced by Bus addresses if True}
 USB_DMA_CACHE_COHERENT:LongBool;      {USB DMA buffers are considered cache coherent if True}
 
 {MMC}
 MMC_AUTOSTART:LongBool = True;        {If True then auto start the MMC/SD subsystem on boot (Only if MMC unit included)}
 MMC_ASYNCSTART:LongBool = True;       {If True then auto start asynchronously using a worker thread instead of the main thread}

 MMC_DMA_ALIGNMENT:LongWord;           {The default alignment for MMC DMA memory allocations}  
 MMC_DMA_MULTIPLIER:LongWord;          {The default multiplier for MMC DMA memory allocations}  
 MMC_DMA_SHARED_MEMORY:LongBool;       {MMC DMA buffers are allocated from Shared memory regions if True}
 MMC_DMA_NOCACHE_MEMORY:LongBool;      {MMC DMA buffers are allocated from Non Cached memory regions if True}
 MMC_DMA_BUS_ADDRESSES:LongBool;       {MMC DMA buffers are referenced by Bus addresses if True}
 MMC_DMA_CACHE_COHERENT:LongBool;      {MMC DMA buffers are considered cache coherent if True}
 
 {USB Hub}
 USB_HUB_MESSAGESLOT_MAXIMUM:LongWord = SIZE_512; {Maximum number of messages for the USB hub messageslot}
 USB_HUB_REGISTER_DRIVER:LongBool = True;         {If True then register the USB HUB driver during boot (Only if USB unit included)(Note: USB cannot function correctly without a hub driver)}
 
 {USB Keyboard}
 USB_KEYBOARD_POLLING_INTERVAL:LongWord = 10;  {Override the default polling interval for a USB keyboard (Milliseconds)}
 USB_KEYBOARD_REGISTER_DRIVER:LongBool = True; {If True then register the USB Keyboard driver during boot (Only if Keyboard unit included)}
 
 {USB Mouse}
 USB_MOUSE_POLLING_INTERVAL:LongWord = 10;  {Override the default polling interval for a USB mouse (Milliseconds)}
 USB_MOUSE_REGISTER_DRIVER:LongBool = True; {If True then register the USB Mouse driver during boot (Only if Mouse unit included)}
 
 {USB Storage}
 USB_STORAGE_FORCE_REMOVABLE:LongBool;        {If True then all USB storage devices will be assumed to be removable}
 USB_STORAGE_REGISTER_DRIVER:LongBool = True; {If True then register the USB Storage driver during boot (Only if Storage unit included)}
 
{==============================================================================}
{Specific Peripheral configuration (Set by PeripheralInit)}
var
 {OHCI}

 {EHCI}
 
 {XHCI}
 
 {AHCI}
 
 {DWCOTG (Synopsys DesignWare Hi-Speed USB 2.0 On-The-Go Controller)}
 DWCOTG_IRQ:LongWord;                 {The IRQ number of the DWCOTG device}
 DWCOTG_POWER_ID:LongWord;            {The power id of the DWCOTG device}
 DWCOTG_REGS_BASE:LongWord;           {The base address of the DWCOTG registers}
 DWCOTG_FIQ_ENABLED:LongBool;         {The DWCOTG device uses Fast Interrupt Requests (FIQ) instead of IRQ}
 DWCOTG_DMA_ALIGNMENT:LongWord;       {The default alignment for DWCOTG DMA memory allocations}
 DWCOTG_DMA_MULTIPLIER:LongWord;      {The default multiplier for DWCOTG DMA memory allocations}
 DWCOTG_DMA_SHARED_MEMORY:LongBool;   {DWCOTG DMA buffers are allocated from Shared memory regions if True}
 DWCOTG_DMA_NOCACHE_MEMORY:LongBool;  {DWCOTG DMA buffers are allocated from Non Cached memory regions if True}
 DWCOTG_DMA_BUS_ADDRESSES:LongBool;   {DWCOTG DMA buffers are referenced by Bus addresses if True}
 DWCOTG_DMA_CACHE_COHERENT:LongBool;  {DWCOTG DMA buffers are considered cache coherent if True}
 DWCOTG_HOST_FRAME_INTERVAL:LongBool; {Update the host frame interval register on root port enable if True}
 //To Do //Number of Channels ?
 
 {SMSC95XX (SMSC LAN95xx USB Ethernet Driver)}
 SMSC95XX_MAC_ADDRESS:String;       {The preconfigured MAC address for an SMSC95XX device}
  
 {BCM2708}
 BCM2708DMA_ALIGNMENT:LongWord;             {The default alignment for BCM2708 DMA memory allocations}
 BCM2708DMA_MULTIPLIER:LongWord;            {The default multiplier for BCM2708 DMA memory allocations}
 BCM2708DMA_SHARED_MEMORY:LongBool;         {BCM2708 DMA control blocks and DMA buffers are allocated from Shared memory regions if True}
 BCM2708DMA_NOCACHE_MEMORY:LongBool;        {BCM2708 DMA control blocks and DMA buffers are allocated from Non Cached memory regions if True}
 BCM2708DMA_BUS_ADDRESSES:LongBool;         {BCM2708 DMA control blocks and DMA buffers are referenced by Bus addresses if True}
 BCM2708DMA_CACHE_COHERENT:LongBool;        {BCM2708 DMA control blocks and DMA buffers are considered cache coherent if True}
 
 BCM2708I2C_COMBINED_WRITEREAD:LongBool;    {If True then the BCM2708 I2C driver can do combined Write/Read transactions}
 
 BCM2708SDHCI_FIQ_ENABLED:LongBool;         {The BCM2708 SDHCI device uses Fast Interrupt Requests (FIQ) instead of IRQ}

 BCM2708ARM_TIMER_FIQ_ENABLED:LongBool;     {The BCM2708 ARM Timer device uses Fast Interrupt Requests (FIQ) instead of IRQ}
 
 BCM2708FRAMEBUFFER_ALIGNMENT:LongWord;     {The memory alignment for the BCM2708 Framebuffer device}
 BCM2708FRAMEBUFFER_CACHED:LongBool;        {If True then the BCM2708 Framebuffer device is in cached memory (Requires CleanCacheRange on write)}
 
 BCM2708_REGISTER_SPI0:LongBool = True;     {If True then register the BCM2708 SPI0 device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_SPI1:LongBool = True;     {If True then register the BCM2708 SPI1 device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_SPI2:LongBool = True;     {If True then register the BCM2708 SPI2 device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_I2C0:LongBool = True;     {If True then register the BCM2708 I2C0 device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_I2C1:LongBool = True;     {If True then register the BCM2708 I2C1 device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_DMA:LongBool = True;      {If True then register the BCM2708 DMA host during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_PWM:LongBool = True;      {If True then register the BCM2708 PWM device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_PCM:LongBool = True;      {If True then register the BCM2708 PCM device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_GPIO:LongBool = True;     {If True then register the BCM2708 GPIO device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_UART0:LongBool = True;    {If True then register the BCM2708 UART0 device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_UART1:LongBool = True;    {If True then register the BCM2708 UART1 device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_SDHCI:LongBool = True;    {If True then register the BCM2708 SDHCI host during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_SPISLAVE:LongBool = True; {If True then register the BCM2708 SPI slave device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_I2CSLAVE:LongBool = True; {If True then register the BCM2708 I2C slave device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_PWMAUDIO:LongBool = True; {If True then register the BCM2708 PWM Audio device during boot (Only if BCM2708 unit included)}

 BCM2708_REGISTER_SYS_CLOCK:LongBool = True; {If True then register the BCM2708 System Timer Clock device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_ARM_CLOCK:LongBool = True; {If True then register the BCM2708 ARM Timer Clock device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_ARM_TIMER:LongBool = True; {If True then register the BCM2708 ARM Timer device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_RANDOM:LongBool = True;   {If True then register the BCM2708 Random device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_MAILBOX:LongBool = True;  {If True then register the BCM2708 Mailbox device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_WATCHDOG:LongBool = True; {If True then register the BCM2708 Watchdog device during boot (Only if BCM2708 unit included)}
 BCM2708_REGISTER_FRAMEBUFFER:LongBool = True; {If True then register the BCM2708 Framebuffer device during boot (Only if BCM2708 unit included)}
 
 {BCM2709}
 BCM2709DMA_ALIGNMENT:LongWord;             {The default alignment for BCM2709 DMA memory allocations}
 BCM2709DMA_MULTIPLIER:LongWord;            {The default multiplier for BCM2709 DMA memory allocations}
 BCM2709DMA_SHARED_MEMORY:LongBool;         {BCM2709 DMA control blocks and DMA buffers are allocated from Shared memory regions if True}
 BCM2709DMA_NOCACHE_MEMORY:LongBool;        {BCM2709 DMA control blocks and DMA buffers are allocated from Non Cached memory regions if True}
 BCM2709DMA_BUS_ADDRESSES:LongBool;         {BCM2709 DMA control blocks and DMA buffers are referenced by Bus addresses if True}
 BCM2709DMA_CACHE_COHERENT:LongBool;        {BCM2709 DMA control blocks and DMA buffers are considered cache coherent if True}

 BCM2709I2C_COMBINED_WRITEREAD:LongBool;    {If True then the BCM2709 I2C driver can do combined Write/Read transactions}
 
 BCM2709SDHCI_FIQ_ENABLED:LongBool;         {The BCM2709 SDHCI device uses Fast Interrupt Requests (FIQ) instead of IRQ}

 BCM2709ARM_TIMER_FIQ_ENABLED:LongBool;     {The BCM2709 ARM Timer device uses Fast Interrupt Requests (FIQ) instead of IRQ}
 BCM2709LOCAL_TIMER_FIQ_ENABLED:LongBool;   {The BCM2709 Local Timer device uses Fast Interrupt Requests (FIQ) instead of IRQ}
 
 BCM2709FRAMEBUFFER_ALIGNMENT:LongWord;     {The memory alignment for the BCM2709 Framebuffer device}
 BCM2709FRAMEBUFFER_CACHED:LongBool;        {If True then the BCM2709 Framebuffer device is in cached memory (Requires CleanCacheRange on write)}
 
 BCM2709_REGISTER_SPI0:LongBool = True;     {If True then register the BCM2709 SPI0 device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_SPI1:LongBool = True;     {If True then register the BCM2709 SPI1 device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_SPI2:LongBool = True;     {If True then register the BCM2709 SPI2 device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_I2C0:LongBool = True;     {If True then register the BCM2709 I2C0 device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_I2C1:LongBool = True;     {If True then register the BCM2709 I2C1 device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_DMA:LongBool = True;      {If True then register the BCM2709 DMA host during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_PWM:LongBool = True;      {If True then register the BCM2709 PWM device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_PCM:LongBool = True;      {If True then register the BCM2709 PCM device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_GPIO:LongBool = True;     {If True then register the BCM2709 GPIO device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_UART0:LongBool = True;    {If True then register the BCM2709 UART0 device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_UART1:LongBool = True;    {If True then register the BCM2709 UART1 device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_SDHCI:LongBool = True;    {If True then register the BCM2709 SDHCI host during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_SPISLAVE:LongBool = True; {If True then register the BCM2709 SPI slave device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_I2CSLAVE:LongBool = True; {If True then register the BCM2709 I2C slave device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_PWMAUDIO:LongBool = True; {If True then register the BCM2709 PWM Audio device during boot (Only if BCM2709 unit included)}
 
 BCM2709_REGISTER_SYS_CLOCK:LongBool = True; {If True then register the BCM2709 System Timer Clock device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_ARM_CLOCK:LongBool = True; {If True then register the BCM2709 ARM Timer Clock device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_LOCAL_CLOCK:LongBool = True; {If True then register the BCM2709 Local Timer Clock device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_ARM_TIMER:LongBool = True; {If True then register the BCM2709 ARM Timer device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_LOCAL_TIMER:LongBool = True; {If True then register the BCM2709 Local Timer device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_RANDOM:LongBool = True;   {If True then register the BCM2709 Random device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_MAILBOX:LongBool = True;  {If True then register the BCM2709 Mailbox device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_WATCHDOG:LongBool = True; {If True then register the BCM2709 Watchdog device during boot (Only if BCM2709 unit included)}
 BCM2709_REGISTER_FRAMEBUFFER:LongBool = True; {If True then register the BCM2709 Framebuffer device during boot (Only if BCM2709 unit included)}

 {BCM2710}
 BCM2710DMA_ALIGNMENT:LongWord;             {The default alignment for BCM2710 DMA memory allocations}
 BCM2710DMA_MULTIPLIER:LongWord;            {The default multiplier for BCM2710 DMA memory allocations}
 BCM2710DMA_SHARED_MEMORY:LongBool;         {BCM2710 DMA control blocks and DMA buffers are allocated from Shared memory regions if True}
 BCM2710DMA_NOCACHE_MEMORY:LongBool;        {BCM2710 DMA control blocks and DMA buffers are allocated from Non Cached memory regions if True}
 BCM2710DMA_BUS_ADDRESSES:LongBool;         {BCM2710 DMA control blocks and DMA buffers are referenced by Bus addresses if True}
 BCM2710DMA_CACHE_COHERENT:LongBool;        {BCM2710 DMA control blocks and DMA buffers are considered cache coherent if True}

 BCM2710I2C_COMBINED_WRITEREAD:LongBool;    {If True then the BCM2710 I2C driver can do combined Write/Read transactions}
 
 BCM2710SDHCI_FIQ_ENABLED:LongBool;         {The BCM2710 SDHCI device uses Fast Interrupt Requests (FIQ) instead of IRQ}

 BCM2710ARM_TIMER_FIQ_ENABLED:LongBool;     {The BCM2710 ARM Timer device uses Fast Interrupt Requests (FIQ) instead of IRQ}
 BCM2710LOCAL_TIMER_FIQ_ENABLED:LongBool;   {The BCM2710 Local Timer device uses Fast Interrupt Requests (FIQ) instead of IRQ}
 
 BCM2710FRAMEBUFFER_ALIGNMENT:LongWord;     {The memory alignment for the BCM2710 Framebuffer device}
 BCM2710FRAMEBUFFER_CACHED:LongBool;        {If True then the BCM2710 Framebuffer device is in cached memory (Requires CleanCacheRange on write)}
 
 BCM2710_REGISTER_SPI0:LongBool = True;     {If True then register the BCM2710 SPI0 device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_SPI1:LongBool = True;     {If True then register the BCM2710 SPI1 device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_SPI2:LongBool = True;     {If True then register the BCM2710 SPI2 device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_I2C0:LongBool = True;     {If True then register the BCM2710 I2C0 device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_I2C1:LongBool = True;     {If True then register the BCM2710 I2C1 device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_DMA:LongBool = True;      {If True then register the BCM2710 DMA host during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_PWM:LongBool = True;      {If True then register the BCM2710 PWM device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_PCM:LongBool = True;      {If True then register the BCM2710 PCM device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_GPIO:LongBool = True;     {If True then register the BCM2710 GPIO device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_UART0:LongBool = True;    {If True then register the BCM2710 UART0 device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_UART1:LongBool = True;    {If True then register the BCM2710 UART1 device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_SDHCI:LongBool = True;    {If True then register the BCM2710 SDHCI host during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_SPISLAVE:LongBool = True; {If True then register the BCM2710 SPI slave device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_I2CSLAVE:LongBool = True; {If True then register the BCM2710 I2C slave device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_PWMAUDIO:LongBool = True; {If True then register the BCM2710 PWM Audio device during boot (Only if BCM2710 unit included)}

 BCM2710_REGISTER_SYS_CLOCK:LongBool = True; {If True then register the BCM2710 System Timer Clock device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_ARM_CLOCK:LongBool = True; {If True then register the BCM2710 ARM Timer Clock device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_LOCAL_CLOCK:LongBool = True; {If True then register the BCM2710 Local Timer Clock device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_ARM_TIMER:LongBool = True; {If True then register the BCM2710 ARM Timer device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_LOCAL_TIMER:LongBool = True; {If True then register the BCM2710 Local Timer device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_RANDOM:LongBool = True;   {If True then register the BCM2710 Random device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_MAILBOX:LongBool = True;  {If True then register the BCM2710 Mailbox device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_WATCHDOG:LongBool = True; {If True then register the BCM2710 Watchdog device during boot (Only if BCM2710 unit included)}
 BCM2710_REGISTER_FRAMEBUFFER:LongBool = True; {If True then register the BCM2710 Framebuffer device during boot (Only if BCM2710 unit included)}
 
 {QEMUVPB}
 QEMUVPB_REGISTER_DMA:LongBool = True;         {If True then register the QEMU VersatilePB DMA device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_UART0:LongBool = True;       {If True then register the QEMU VersatilePB UART0 device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_UART1:LongBool = True;       {If True then register the QEMU VersatilePB UART1 device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_UART2:LongBool = True;       {If True then register the QEMU VersatilePB UART2 device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_UART3:LongBool = True;       {If True then register the QEMU VersatilePB UART3 device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_RTC:LongBool = True;         {If True then register the QEMU VersatilePB RTC device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_CLOCK:LongBool = True;       {If True then register the QEMU VersatilePB 24MHz Clock device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_MMC0:LongBool = True;        {If True then register the QEMU VersatilePB MMC0 device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_MMC1:LongBool = True;        {If True then register the QEMU VersatilePB MMC1 device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_NETWORK:LongBool = True;     {If True then register the QEMU VersatilePB Network device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_FRAMEBUFFER:LongBool = True; {If True then register the QEMU VersatilePB Framebuffer device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_MOUSE:LongBool = True;       {If True then register the QEMU VersatilePB Mouse device during boot (Only if QEMUVersatilePB unit included)}
 QEMUVPB_REGISTER_KEYBOARD:LongBool = True;    {If True then register the QEMU VersatilePB Keyboard device during boot (Only if QEMUVersatilePB unit included)}
 
{==============================================================================}
{Country, CodePage, Locale and Language configuration}
var
 COUNTRY_DEFAULT:LongWord = 0;             {The current default country code}
 
 CODEPAGE_OEM_DEFAULT:LongWord = 437;      {The current OEM default code page}
 CODEPAGE_ANSI_DEFAULT:LongWord = 1252;    {The current ANSI default code page}
 
 CODEPAGE_CONSOLE_INPUT:LongWord = 1252;   {The current console input code page}
 CODEPAGE_CONSOLE_OUTPUT:LongWord = 1252;  {The current console output code page}
 
 LOCALE_DEFAULT:LongWord; {LCID}           {The current default locale}
 LANGUAGE_DEFAULT:Word;   {LANGID}         {The current default language identifier}
 
 KEYMAP_DEFAULT:String = 'US';             {The name of the default keymap}
 
{==============================================================================}
{Disk, Controller, Filesystem and Cache configuration}
var
 {Filesystem configuration}
 FILESYS_AUTOSTART:LongBool = True;              {If True then auto start the filesystem on boot (Only if FileSystem unit included)}
 FILESYS_ASYNCSTART:LongBool = True;             {If True then auto start asynchronously using a worker thread instead of the main thread}

 FILESYS_REGISTER_LOGGING:LongBool = True;       {If True then register filesystem as a Logging device on boot (Only if FileSystem unit included)}
 FILESYS_LOGGING_DEFAULT:LongBool = False;       {If True then filesystem can be the default Logging device (Only if FileSystem unit included)}
 FILESYS_LOGGING_FILE:String;                    {The name of the file to log messages to}
 FILESYS_LOGGING_MAXSIZE:LongWord;               {The maximum size of the logging file before rollover (0 for no maximum)}
 FILESYS_LOGGING_MAXCOPIES:LongWord;             {The number of old logging files to keep on rollover (0 for no copies)}
 
 {Cache configuration} 
 FILESYS_CACHE_SIZE:LongWord = SIZE_16M;                     {The default filesystem cache size}
 FILESYS_CACHE_PAGE:LongWord = SIZE_32K;                     {The size of a filesystem cache page}
 FILESYS_CACHE_KEYS:LongWord = 12;                           {The number of hash keys for the filesystem cache}
 FILESYS_CACHE_MODE:LongWord = FILESYS_CACHE_MODE_READWRITE; {The default filesystem cache mode}
 
 {Filesystem configuration}
 FILESYS_FLOPPY_ENABLED:LongBool = True;          {Enable filesystem floppy drive support}
 FILESYS_DRIVES_ENABLED:LongBool = True;          {Enable filesystem drive letter support}
 
 FILESYS_ATA_ENABLED:LongBool = True;             {Enable filesystem ATA controller support}
 FILESYS_ATAPI_ENABLED:LongBool = True;           {Enable filesystem ATAPI controller support}
 FILESYS_SCSI_ENABLED:LongBool = True;            {Enable filesystem SCSI controller support}
 FILESYS_USB_ENABLED:LongBool = True;             {Enable filesystem USB controller support}
 FILESYS_MMC_ENABLED:LongBool = True;             {Enable filesystem MMC/SD controller support}
 FILESYS_VIRTUAL_ENABLED:LongBool = True;         {Enable filesystem virtual disk controller support}
 
 FILESYS_FAT_ENABLED:LongBool = True;             {Enable FAT filesystem support}
 FILESYS_NTFS_ENABLED:LongBool = True;            {Enable NTFS filesystem support}
 FILESYS_EXTFS_ENABLED:LongBool = True;           {Enable EXTFS filesystem support}
 FILESYS_CDFS_ENABLED:LongBool = True;            {Enable CDFS filesystem support}
 
 FILESYS_CASE_FLAGS:LongBool = True;              {Enable support for case flags in filesystem entries (Where Applicable)}
 FILESYS_LONG_NAMES:LongBool = True;              {Enable support for long file names (greater than 8.3) (Where Applicable)}
 FILESYS_OEM_CONVERT:LongBool = True;             {Enable support for ANSI to OEM / OEM to ANSI character set conversion (Where Applicable)}
 FILESYS_NUMERIC_TAIL:LongBool = True;            {Enable support for numeric tail on generated short file names (Where Applicable)}
 FILESYS_DIRTY_CHECK:LongBool = True;             {Enable support for dirty check on volume mount (Where Applicable)}
 FILESYS_QUICK_CHECK:LongBool = True;             {Enable support for quick volume checking (Where Applicable)}
 FILESYS_UPDATE_ACCESSTIME:LongBool = True;       {Enable support for updating last access time field (Where Applicable)}
 
 {FAT configuration}
 FAT_DEFAULT:LongBool = True;                     {Enable default recognition of non partitioned media as FAT}
 FAT_CASE_FLAGS:LongBool = True;                  {Enable support for case flags in FAT filesystem entries}
 FAT_LONG_NAMES:LongBool = True;                  {Enable support for FAT long file names (greater than 8.3)}
 FAT_OEM_CONVERT:LongBool = True;                 {Enable support for FAT ANSI to OEM / OEM to ANSI character set conversion}
 FAT_NUMERIC_TAIL:LongBool = True;                {Enable support for numeric tail on generated FAT short file names}
 FAT_DIRTY_CHECK:LongBool = True;                 {Enable support for dirty check on FAT volume mount}
 FAT_QUICK_CHECK:LongBool = True;                 {Enable support for quick FAT volume checking}
 
 {NTFS configuration}
 NTFS_DEFAULT:LongBool = False;                   {Enable default recognition of non partitioned media as NTFS}
 NTFS_RESET_LOG:LongBool = True;                  {Reset the NTFS Log File if it was dirty on mount}
 NTFS_FIXED_ZONE:LongBool = True;                 {Use the Windows Vista/2008/7 Fixed MFT Zone values (not the Windows NT/2000/XP percentages)}
 NTFS_ALT_LAYOUT:LongBool = False;                {Use the Windows Vista/2008/7 Volume Layout values (not the Windows NT/2000/XP layout)}
 NTFS_LENIENT:LongBool = False;                   {Allow certain non fatal errors to be ignored}
 NTFS_DEFENSIVE:LongBool = False;                 {Perform more defensive checking of structures and values}
 NTFS_AGGRESSIVE:LongBool = False;                {Attempt to correct certain errors during operation}
 NTFS_NO_SHORT_NAMES:LongBool = False;            {Do not create alternate short file names}
 NTFS_NULL_SECURITY:LongBool = False;             {Do not apply security when creating files and folders (only apply security when SetSecurity called)}
 NTFS_DEFAULT_SECURITY:LongBool = False;          {Apply default permissions (Everyone, Full Control) when creating files and folders}
 
 {EXTFS configuration}
 EXTFS_DEFAULT:LongBool = False;                  {Enable default recognition of non partitioned media as EXTFS}
 
 {CDFS configuration}
 CDFS_DEFAULT:LongBool = False;                   {Enable default recognition of non partitioned media as CDFS}
 CDFS_LONG_NAMES:LongBool = True;                 {Enable support for CDFS long file names (greater than 8.3)}
 CDFS_SWAP_SERIAL:LongBool = False;               {Swap the byte order of the CDFS serial number (Set to True for Windows 9x compatibility)}
 
{==============================================================================}
{Network, Transport, Protocol and Sockets configuration}
var
 {Host configuration}
 HOST_NAME:String = 'localhost';                  {The network host name of the local machine}
 HOST_DOMAIN:String = 'localdomain';              {The network domain name of the local machine}
 
 {Winsock configuration} 
 WINSOCK_NAME:String = 'Ultibo Winsock Version 1.1';
 WINSOCK_LOW_VERSION:Word = $101;
 WINSOCK_HIGH_VERSION:Word = $101;
 WINSOCK_BUILD_VERSION:String = '1.10.43';
 
 WINSOCK_MAX_SOCKETS:Word = SIZE_1K;
 WINSOCK_MAX_UDP:Word = SIZE_8K;
 
 WINSOCK_AUTOSTART:LongBool = True;       {If True then auto start the Winsock layer on boot (Only if Winsock unit included)} 
 WINSOCK_ASYNCSTART:LongBool = True;      {If True then auto start asynchronously using a worker thread instead of the main thread}
 
 {Winsock2 configuration} 
 WINSOCK2_NAME:String = 'Ultibo Winsock Version 2.2';
 WINSOCK2_LOW_VERSION:Word = $101;
 WINSOCK2_HIGH_VERSION:Word = $202;
 WINSOCK2_BUILD_VERSION:String = '2.20.03';
 
 WINSOCK2_MAX_SOCKETS:Word = SIZE_1K;     {Note: As per Winsock2 specification, this value is for compatibility only and is ignored by the network stack}
 WINSOCK2_MAX_UDP:Word = SIZE_8K;         {Note: As per Winsock2 specification, this value is for compatibility only and is ignored by the network stack}
 
 WINSOCK2_AUTOSTART:LongBool = True;      {If True then auto start the Winsock2 layer on boot (Only if Winsock2 unit included)} 
 WINSOCK2_ASYNCSTART:LongBool = True;     {If True then auto start asynchronously using a worker thread instead of the main thread}
 
 {Sockets configuration}
 SOCKETS_AUTOSTART:LongBool = True;       {If True then auto start the sockets layer on boot (Only if Sockets unit included)} 
 SOCKETS_ASYNCSTART:LongBool = True;      {If True then auto start asynchronously using a worker thread instead of the main thread}
 
 {Client configuration}
 DNS_CLIENT_ENABLED:LongBool = True;            {DNS client is enabled if True}
 
 {Protocol configuration}
 RAW_PROTOCOL_ENABLED:LongBool = True;          {Raw socket protocol is enabled if True}
 UDP_PROTOCOL_ENABLED:LongBool = True;          {UDP protocol is enabled if True}
 TCP_PROTOCOL_ENABLED:LongBool = True;          {TCP protocol is enabled if True}
 ICMP_PROTOCOL_ENABLED:LongBool = True;         {ICMP protocol is enabled if True}
 ICMP6_PROTOCOL_ENABLED:LongBool = False;       {ICMPv6 protocol is enabled if True}
 IGMP_PROTOCOL_ENABLED:LongBool = True;         {IGMP protocol is enabled if True}

 TCP_MIN_BACKLOG:LongWord = 5;                  {Minimum accept queue length for listening sockets (per socket)}
 TCP_MAX_BACKLOG:LongWord = 200;                {Maximum accept queue length for listening sockets (per socket)}
 TCP_RECEIVE_BACKLOG:LongWord = SIZE_1K;        {Queue length for SYN received connections (per listening socket)}
 
 ARP_CONFIG_ENABLED:LongBool = True;            {ARP configuration is enabled if True}
 RARP_CONFIG_ENABLED:LongBool = False;          {RARP configuration is enabled if True}
 BOOTP_CONFIG_ENABLED:LongBool = False;         {BOOTP configuration is enabled if True}
 DHCP_CONFIG_ENABLED:LongBool = True;           {DHCP configuration is enabled if True}
 STATIC_CONFIG_ENABLED:LongBool = True;         {Static configuration is enabled if True}
 LOOPBACK_CONFIG_ENABLED:LongBool = True;       {Loopback configuration is enabled if True}
 
 {Transport configuration}
 IP_TRANSPORT_ENABLED:LongBool = True;          {IP transport is enabled if True}
 IP6_TRANSPORT_ENABLED:LongBool = False;        {IPv6 transport is enabled if True}
 ARP_TRANSPORT_ENABLED:LongBool = True;         {ARP transport is enabled if True}
 RARP_TRANSPORT_ENABLED:LongBool = True;        {RARP transport is enabled if True}
 
 RSN_TRANSPORT_ENABLED:LongBool = True;         {RSN transport is enabled if True}
 EAPOL_TRANSPORT_ENABLED:LongBool = True;       {EAPOL transport is enabled if True}
 
 {Network configuration}
 WIRED_NETWORK_ENABLED:LongBool = True;         {Wired network adapters are enabled if True}
 LOOPBACK_NETWORK_ENABLED:LongBool = True;      {Loopback network adapter is enabled if True}
 WIRELESS_NETWORK_ENABLED:LongBool = True;      {Wireless network adapters are enabled if True}
 
{==============================================================================}
{Shell configuration}
var
 CONSOLE_SHELL_ENABLED:LongBool = True;         {If True then automatically create a console shell window when a new console is registered (Only if ConsoleShell unit included)}
 CONSOLE_SHELL_POSITION:LongWord = CONSOLE_POSITION_RIGHT; {The default Console Window position for the console shell}
 CONSOLE_SHELL_DEVICE:String;                   {The console device Name (or Description) to create the shell window on, if blank create on default device unless forced (Only if ConsoleShell unit included)}
 
{==============================================================================}
{Specific Service configuration}
var
 {NTP}
 NTP_SERVER_DEFAULT:String = 'pool.ntp.org';    {The default NTP server(s) to poll}
 NTP_PORT_DEFAULT:Word = 123;                   {The default NTP port to poll}
 NTP_POLLING_INTERVAL:LongWord = 300;           {The default NTP polling interval (300 seconds / 5 minutes)}
 NTP_POLLING_TIMEOUT:LongWord = 2000;           {The default NTP polling timeout (2000 milliseconds / 2 seconds)}
 NTP_POLLING_RETRIES:LongWord = 3;              {The default NTP polling retry count}
 NTP_RETRY_TIMEOUT:LongWord = 1000;             {The default NTP retry interval (1000 milliseconds / 1 second)}
 
 NTP_AUTOSTART:LongBool = True;                 {If True then auto start the NTP client on boot (Only if Services unit included)}
 
var
 {Telnet}
 TELNET_PORT_DEFAULT:Word = 23;                 {The default Telnet port}
 
 TELNET_AUTOSTART:LongBool = True;              {If True then auto start the Telnet server on boot (Only if RemoteShell unit included)}
 
var
 {SSH}
 SSH_PORT_DEFAULT:Word = 22;                    {The default SSH port}
 
 SSH_AUTOSTART:LongBool = True;                 {If True then auto start the SSH server on boot (Only if RemoteShell unit included)}
 
var
 {SysLog}
 SYSLOG_BOUND_PORT:Word;                        {The local port for SysLog to bind to (0 for dynamic port)}
 
 SYSLOG_SERVER_DEFAULT:String = '127.0.0.1';    {The default SysLog server to send messages to}
 SYSLOG_PORT_DEFAULT:Word = 514;                          {The default SysLog port}
 SYSLOG_PROTOCOL_DEFAULT:LongWord = LOGGING_PROTOCOL_UDP; {The default SysLog protocol}
 SYSLOG_OCTET_COUNTING:LongBool;                {If True use the Octet Counting method of framing the SysLog message (LOGGING_PROTOCOL_TCP only)(See: RFC6587)}
 
 SYSLOG_AUTOSTART:LongBool = True;              {If True then auto start the SysLog client on boot (Only if Services unit included)}
 
 SYSLOG_REGISTER_LOGGING:LongBool = True;       {If True then register SysLog as a Logging device on boot (Only if Services unit included)}
 SYSLOG_LOGGING_DEFAULT:LongBool = True;        {If True then SysLog can be the default Logging device (Only if Services unit included)}
 
var
 {POP3}
 POP3_PORT_DEFAULT:Word = 110;                  {The default POP3 port}

var
 {IMAP4}
 IMAP4_PORT_DEFAULT:Word = 143;                 {The default IMAP4 port}

var
 {SMTP}
 SMTP_PORT_DEFAULT:Word = 25;                   {The default SMTP port}
 
var
 {HTTP}
 HTTP_PORT_DEFAULT:Word = 80;                   {The default HTTP port}
 HTTPS_PORT_DEFAULT:Word = 443;                 {The default HTTPS port}
 
var
 {CIFS}
 CIFS_PORT_DEFAULT:Word = 445;                  {The default CIFS port}

 CIFS_CLIENT_AUTOSTART:LongBool = True;         {If True then auto start the CIFS client on boot (Only if CIFS unit included)}
 CIFS_SERVER_AUTOSTART:LongBool = True;         {If True then auto start the CIFS server on boot (Only if CIFS unit included)}
 
var
 {NFS}
 NFS_PORT_DEFAULT:Word = 111;                   {The default NFS port}
 NFSv4_PORT_DEFAULT:Word = 2049;                {The default NFSv4 port}
 
 NFS_CLIENT_AUTOSTART:LongBool = True;          {If True then auto start the NFS client on boot (Only if NFS unit included)}
 NFS_SERVER_AUTOSTART:LongBool = True;          {If True then auto start the NFS server on boot (Only if NFS unit included)}
 
{==============================================================================}
{Specific Driver configuration}
var
 {PL2303}
 PL2303_MAX_TRANSMIT:LongWord;                  {The maximum transmit size of the PL2303 USB to Serial converter (Defaults to maximum supported by the device if not specified)}

 {FTDI Serial}
 FTDISERIAL_MAX_TRANSMIT:LongWord;              {The maximum transmit size of the FTDI USB to Serial converter (Defaults to maximum supported by the device if not specified)}
 
 {USB CDC ACM}
 CDCACM_MAX_TRANSMIT:LongWord;                  {The maximum transmit size for USB CDC ACM Serial devices (Defaults to maximum supported by the device if not specified)}
 
 {DS1307}
 DS1307_CHIP_TYPE:LongWord;                     {The specific chip to support in the DS1307 driver (See the DS1307_CHIP_* constants in the driver)}
 DS1307_I2C_ADDRESS:Word = $68;                 {The I2C address to use for the DS1307 RTC device}
 DS1307_I2C_DEVICE:String = 'I2C0';             {The I2C device (Name or Description) to use for the DS1307 RTC device}
 
 {RT2800USB}
 RT2800USB_HARDWARE_ENCRYPTION_DISABLED:LongBool; {If True then use software only encryption for RT2800USB}
 
 {AF16x2LCD}
 AF16X2LCD_AUTOSTART:LongBool = True;           {If True then auto start the AF16x2LCD device on boot (Only if AF16x2LCD unit included)}

 {PiTFT28}
 PiTFT28_AUTOSTART:LongBool = True;             {If True then auto start the PiTFT28 device on boot (Only if PiTFT28 unit included)}

 {PiTFT35}
 PiTFT35_AUTOSTART:LongBool = True;             {If True then auto start the PiTFT35 device on boot (Only if PiTFT35 unit included)}
 
{==============================================================================}
{Global handlers}
var
 GetLastErrorHandler:TGetLastError;
 SetLastErrorHandler:TSetLastError;

{==============================================================================}
{Global functions}
function Min(A,B:LongInt):LongInt; inline;
function Max(A,B:LongInt):LongInt; inline;

function Clamp(Value,Low,High:LongInt):LongInt;

function RoundUp(Value,Multiple:LongWord):LongWord; 
function RoundDown(Value,Multiple:LongWord):LongWord;

function DivRoundUp(Value,Divisor:LongInt):LongWord;
function DivRoundClosest(Value,Divisor:LongInt):LongWord;

function IsPowerOf2(Value:LongWord):Boolean;

function HIWORD(L:LongInt):Word; inline;
function LOWORD(L:LongInt):Word; inline;

function HIBYTE(W:LongInt):Byte; inline;
function LOBYTE(W:LongInt):Byte; inline;

function MAKELONG(A,B:LongInt):LongInt; inline;
function MAKEWORD(A,B:LongInt):Word; inline;

function MAKELANGID(PrimaryLang,SubLang:USHORT):WORD; inline;

function WordNtoBE(Value:Word):Word; inline;
function WordBEtoN(Value:Word):Word; inline;

function WordNtoLE(Value:Word):Word; inline;
function WordLEtoN(Value:Word):Word; inline;

function LongWordNtoBE(Value:LongWord):LongWord; inline;
function LongWordBEtoN(Value:LongWord):LongWord; inline;

function LongWordNtoLE(Value:LongWord):LongWord; inline;
function LongWordLEtoN(Value:LongWord):LongWord; inline;

function Int64NtoBE(const Value:Int64):Int64; inline;
function Int64BEtoN(const Value:Int64):Int64; inline;

function Int64NtoLE(const Value:Int64):Int64; inline;
function Int64LEtoN(const Value:Int64):Int64; inline;

function BCDtoBin(Value:Byte):Byte; inline;
function BintoBCD(Value:Byte):Byte; inline;

function GetLastError:LongWord; inline;
procedure SetLastError(LastError:LongWord); inline;

function StringHash(const Text:String):LongWord;

{==============================================================================}
{Conversion functions}
function ErrorToString(Error:LongWord):String;
function SysErrorToString(ErrorCode:Integer):String;

function BooleanToString(Value:Boolean):String;

function CPUArchToString(CPUArch:LongWord):String;
function CPUTypeToString(CPUType:LongWord):String;
function CPUModelToString(CPUModel:LongWord):String;
function CPUIDToString(CPUID:LongWord):String;
function CPUGroupToString(CPUGroup:LongWord):String;

function FPUTypeToString(FPUType:LongWord):String;
function GPUTypeToString(GPUType:LongWord):String;

function CacheTypeToString(CacheType:LongWord):String;

function BoardTypeToString(BoardType:LongWord):String;
function MachineTypeToString(MachineType:LongWord):String;

function PowerIDToString(PowerID:LongWord):String;
function PowerStateToString(PowerState:LongWord):String;

function ClockIDToString(ClockID:LongWord):String;
function ClockStateToString(ClockState:LongWord):String;

function TurboIDToString(TurboID:LongWord):String;

function VoltageIDToString(VoltageID:LongWord):String;

function TemperatureIDToString(TemperatureID:LongWord):String;

function ColorFormatToBytes(Format:LongWord):LongWord;
function ColorFormatToString(Format:LongWord):String;

procedure ColorDefaultToFormat(Format,Color:LongWord;Dest:Pointer;Reverse:Boolean); inline;
procedure ColorFormatToDefault(Format:LongWord;Source:Pointer;var Color:Longword;Reverse:Boolean); inline;
procedure ColorDefaultAltToFormat(Format,Color:LongWord;Dest:Pointer;Reverse:Boolean); {Not inline}
procedure ColorFormatAltToDefault(Format:LongWord;Source:Pointer;var Color:Longword;Reverse:Boolean); inline;

procedure PixelsDefaultToFormat(Format:LongWord;Source,Dest:Pointer;Count:LongWord;Reverse:Boolean); 
procedure PixelsFormatToDefault(Format:LongWord;Source,Dest:Pointer;Count:LongWord;Reverse:Boolean);
procedure PixelsDefaultAltToFormat(Format:LongWord;Source,Dest:Pointer;Count:LongWord;Reverse:Boolean); 
procedure PixelsFormatAltToDefault(Format:LongWord;Source,Dest:Pointer;Count:LongWord;Reverse:Boolean);

function LogLevelToLoggingSeverity(LogLevel:LongWord):LongWord;

{==============================================================================}
{==============================================================================}

implementation

{==============================================================================}
{==============================================================================}
{Global functions}
function Min(A,B:LongInt):LongInt; inline;
begin
 {}
 if A < B then Result:=A else Result:=B;
end;

{==============================================================================}

function Max(A,B:LongInt):LongInt; inline;
begin
 {}
 if A > B then Result:=A else Result:=B;
end;

{==============================================================================}

function Clamp(Value,Low,High:LongInt):LongInt;
begin
 {}
 Result:=Min(Max(Value,Low),High);
end;

{==============================================================================}

function RoundUp(Value,Multiple:LongWord):LongWord; 
begin
 {}
 if Multiple > 0 then
  begin
   if (Value mod Multiple) <> 0 then
    begin
     Result:=((Value div Multiple) * Multiple) + Multiple;
    end
   else
    begin
     Result:=Value;
    end;    
  end
 else
  begin
   Result:=Value;
  end;  
end;

{==============================================================================}

function RoundDown(Value,Multiple:LongWord):LongWord; 
begin
 {}
 if Multiple > 0 then
  begin
   if (Value mod Multiple) <> 0 then
    begin
     Result:=(Value div Multiple) * Multiple;
    end
   else
    begin
     Result:=Value;
    end;    
  end
 else
  begin
   Result:=Value;
  end;  
end;

{==============================================================================}

function DivRoundUp(Value,Divisor:LongInt):LongWord;
begin
 {}
 Result:=0;
 
 if Divisor = 0 then Exit;
 
 Result:=((Value + Divisor) - 1) div Divisor;
end;

{==============================================================================}

function DivRoundClosest(Value,Divisor:LongInt):LongWord;
begin
 {}
 if ((Value - 1) > 0) or ((Divisor - 1) > 0) or (Value > 0) then
  begin
   Result:=(Value + (Divisor div 2)) div Divisor;
  end
 else
  begin
   Result:=(Value - (Divisor div 2)) div Divisor;
  end;
end;

{==============================================================================}

function IsPowerOf2(Value:LongWord):Boolean;
begin
 {}
 Result:=(Value <> 0) and ((Value and (Value - 1)) = 0);
end;

{==============================================================================}

function HIWORD(L:LongInt):Word; inline;
begin
 {}
 Result:=Word(((DWORD(L)) shr 16) and $FFFF);
end;

{==============================================================================}

function LOWORD(L:LongInt):Word; inline;
begin
 {}
 Result:=Word(L);
end;

{==============================================================================}

function HIBYTE(W:LongInt):Byte; inline;
begin
 {}
 Result:=Byte(((Word(W)) shr 8) and $FF);
end;

{==============================================================================}

function LOBYTE(W:LongInt):Byte; inline;
begin
 {}
 Result:=Byte(W);
end;

{==============================================================================}

function MAKELONG(A,B:LongInt):LongInt; inline;
begin
 {}
 Result:=LongInt((Word(A)) or ((DWORD(Word(A))) shl 16));
end;

{==============================================================================}

function MAKEWORD(A,B:LongInt):Word; inline;
begin
 {}
 Result:=Word((Byte(A)) or ((Word(Byte(B))) shl 8));
end;

{==============================================================================}

function MAKELANGID(PrimaryLang,SubLang:USHORT):WORD; inline;
{Construct a language identifier from a primary language and a sub language}
begin
 {}
 Result:=(SubLang shl 10) or PrimaryLang;
end;

{==============================================================================}

function WordNtoBE(Value:Word):Word; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=NtoBE(Value);
end;

{==============================================================================}

function WordBEtoN(Value:Word):Word; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=BEtoN(Value);
end;

{==============================================================================}

function WordNtoLE(Value:Word):Word; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=NtoLE(Value);
end;

{==============================================================================}

function WordLEtoN(Value:Word):Word; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=LEtoN(Value);
end;

{==============================================================================}

function LongWordNtoBE(Value:LongWord):LongWord; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=NtoBE(Value);
end;

{==============================================================================}

function LongWordBEtoN(Value:LongWord):LongWord; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=BEtoN(Value);
end;

{==============================================================================}

function LongWordNtoLE(Value:LongWord):LongWord; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=NtoLE(Value);
end;

{==============================================================================}

function LongWordLEtoN(Value:LongWord):LongWord; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=LEtoN(Value);
end;

{==============================================================================}

function Int64NtoBE(const Value:Int64):Int64; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=NtoBE(Value);
end;

{==============================================================================}

function Int64BEtoN(const Value:Int64):Int64; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=BEtoN(Value);
end;

{==============================================================================}

function Int64NtoLE(const Value:Int64):Int64; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=NtoLE(Value);
end;

{==============================================================================}

function Int64LEtoN(const Value:Int64):Int64; inline;
{These functions are simply wrappers to force the compiler to select the correct function without typecasting}
begin
 {}
 Result:=LEtoN(Value);
end;

{==============================================================================}

function BCDtoBin(Value:Byte):Byte; inline;
begin
 {}
 Result:=(Value and $0F) + ((Value shr 4) * 10);
end;

{==============================================================================}

function BintoBCD(Value:Byte):Byte; inline;
begin
 {}
 Result:=((Value div 10) shl 4) + (Value mod 10);
end;

{==============================================================================}

function GetLastError:LongWord; inline;
begin
 {}
 if Assigned(GetLastErrorHandler) then
  begin
   Result:=GetLastErrorHandler(); {Brackets required for objfpc mode}
  end
 else
  begin
   Result:=ERROR_SUCCESS;
  end;  
end;

{==============================================================================}

procedure SetLastError(LastError:LongWord); inline;
begin
 {}
 if Assigned(SetLastErrorHandler) then
  begin
   SetLastErrorHandler(LastError);
  end;
end;

{==============================================================================}

function StringHash(const Text:String):LongWord;
{Calculate the sum of (byte value + 1) * (position + 257) for all bytes in an uppercase string}

{Note: Case Insensitive Hash}
var
 Count:Integer;
 Value:LongWord;
begin
 {}
 Result:=0;
 
 if Length(Text) = 0 then Exit;
 
 for Count:=1 to Length(Text) do
  begin
   Value:=Ord(Text[Count]);
   if (Value >= 97) and (Value <= 122) then
    begin
     Result:=Result + (((Value - 32) + 1) * (LongWord(Count) + 257));
    end
   else
    begin
     Result:=Result + ((Value + 1) * (LongWord(Count) + 257));
    end;
  end;
end;

{==============================================================================}
{==============================================================================}
{Conversion functions}
function ErrorToString(Error:LongWord):String;
begin
 {}
 Result:='ERROR_UNKNOWN';
 
 case Error of
  {Universal Error constants}
  ERROR_SUCCESS:Result:='ERROR_SUCCESS';
  ERROR_INVALID_FUNCTION:Result:='ERROR_INVALID_FUNCTION';
  ERROR_FILE_NOT_FOUND:Result:='ERROR_FILE_NOT_FOUND';
  ERROR_PATH_NOT_FOUND:Result:='ERROR_PATH_NOT_FOUND';
  ERROR_TOO_MANY_OPEN_FILES:Result:='ERROR_TOO_MANY_OPEN_FILES';
  ERROR_ACCESS_DENIED:Result:='ERROR_ACCESS_DENIED';
  ERROR_INVALID_HANDLE:Result:='ERROR_INVALID_HANDLE';
  ERROR_NOT_ENOUGH_MEMORY:Result:='ERROR_NOT_ENOUGH_MEMORY';
  
  ERROR_INVALID_ACCESS:Result:='ERROR_INVALID_ACCESS';
  ERROR_INVALID_DATA:Result:='ERROR_INVALID_DATA';
  ERROR_OUTOFMEMORY:Result:='ERROR_OUTOFMEMORY';
  ERROR_INVALID_DRIVE:Result:='ERROR_INVALID_DRIVE';
  ERROR_CURRENT_DIRECTORY:Result:='ERROR_CURRENT_DIRECTORY';
  ERROR_NOT_SAME_DEVICE:Result:='ERROR_NOT_SAME_DEVICE';
  ERROR_NO_MORE_FILES:Result:='ERROR_NO_MORE_FILES';
  ERROR_WRITE_PROTECT:Result:='ERROR_WRITE_PROTECT';
  ERROR_BAD_UNIT:Result:='ERROR_BAD_UNIT';
  ERROR_NOT_READY:Result:='ERROR_NOT_READY';
  ERROR_BAD_COMMAND:Result:='ERROR_BAD_COMMAND';
 
  ERROR_WRITE_FAULT:Result:='ERROR_WRITE_FAULT';
  ERROR_READ_FAULT:Result:='ERROR_READ_FAULT';
  ERROR_GEN_FAILURE:Result:='ERROR_GEN_FAILURE';
 
  ERROR_NOT_SUPPORTED:Result:='ERROR_NOT_SUPPORTED';
 
  ERROR_DEV_NOT_EXIST:Result:='ERROR_DEV_NOT_EXIST';
 
  ERROR_BAD_DEV_TYPE:Result:='ERROR_BAD_DEV_TYPE';
 
  ERROR_ALREADY_ASSIGNED:Result:='ERROR_ALREADY_ASSIGNED';
  ERROR_INVALID_PASSWORD:Result:='ERROR_INVALID_PASSWORD';
  ERROR_INVALID_PARAMETER:Result:='ERROR_INVALID_PARAMETER';
 
  ERROR_SEM_IS_SET:Result:='ERROR_SEM_IS_SET';
  ERROR_OPEN_FAILED:Result:='ERROR_OPEN_FAILED';
  ERROR_CALL_NOT_IMPLEMENTED:Result:='ERROR_CALL_NOT_IMPLEMENTED';
  ERROR_INSUFFICIENT_BUFFER:Result:='ERROR_INSUFFICIENT_BUFFER';
  ERROR_WAIT_NO_CHILDREN:Result:='ERROR_WAIT_NO_CHILDREN';
  
  ERROR_NOT_LOCKED:Result:='ERROR_NOT_LOCKED';
 
  ERROR_LOCK_FAILED:Result:='ERROR_LOCK_FAILED';
 
  ERROR_ALREADY_EXISTS:Result:='ERROR_ALREADY_EXISTS';
 
  ERROR_ENVVAR_NOT_FOUND:Result:='ERROR_ENVVAR_NOT_FOUND';
 
  ERROR_LOCKED:Result:='ERROR_LOCKED';

  ERROR_MORE_DATA:Result:='ERROR_MORE_DATA';

  ERROR_WAIT_TIMEOUT:Result:='ERROR_WAIT_TIMEOUT';
  ERROR_NO_MORE_ITEMS:Result:='ERROR_NO_MORE_ITEMS';
 
  ERROR_NOT_OWNER:Result:='ERROR_NOT_OWNER';
 
  ERROR_OPERATION_ABORTED:Result:='ERROR_OPERATION_ABORTED';
  ERROR_IO_INCOMPLETE:Result:='ERROR_IO_INCOMPLETE';
  ERROR_IO_PENDING:Result:='ERROR_IO_PENDING';
 
  ERROR_CAN_NOT_COMPLETE:Result:='ERROR_CAN_NOT_COMPLETE';
 
  ERROR_NOT_FOUND:Result:='ERROR_NOT_FOUND';
 
  ERROR_INVALID_ACL:Result:='ERROR_INVALID_ACL';
  ERROR_INVALID_SID:Result:='ERROR_INVALID_SID';
  ERROR_INVALID_SECURITY_DESCR:Result:='ERROR_INVALID_SECURITY_DESCR';
 
  ERROR_TIMEOUT:Result:='ERROR_TIMEOUT';
 
  ERROR_FUNCTION_FAILED:Result:='ERROR_FUNCTION_FAILED';
 
  {Errors below here have no compatibility equivalent}
  ERROR_NOT_VALID:Result:='ERROR_NOT_VALID';
  ERROR_NOT_ASSIGNED:Result:='ERROR_NOT_ASSIGNED';
  ERROR_IN_USE:Result:='ERROR_IN_USE';
  ERROR_OPERATION_FAILED:Result:='ERROR_OPERATION_FAILED';
  ERROR_NOT_OPEN:Result:='ERROR_NOT_OPEN';
  ERROR_ALREADY_OPEN:Result:='ERROR_ALREADY_OPEN';
  ERROR_WAIT_ABANDONED:Result:='ERROR_WAIT_ABANDONED';
  ERROR_IN_PROGRESS:Result:='ERROR_IN_PROGRESS';
  ERROR_RUNTIME_ERROR:Result:='ERROR_RUNTIME_ERROR';
  ERROR_EXCEPTION:Result:='ERROR_EXCEPTION';
  ERROR_NOT_PROCESSED:Result:='ERROR_NOT_PROCESSED';
  ERROR_NOT_COMPLETED:Result:='ERROR_NOT_COMPLETED';
  ERROR_NOT_COMPATIBLE:Result:='ERROR_NOT_COMPATIBLE';
  ERROR_CANCELLED:Result:='ERROR_CANCELLED';
  ERROR_NOT_EXACT:Result:='ERROR_NOT_EXACT';
  ERROR_ALREADY_OWNER:Result:='ERROR_ALREADY_OWNER';
  
  ERROR_UNKNOWN:Result:='ERROR_UNKNOWN';
 end;
end;

{==============================================================================}

function SysErrorToString(ErrorCode:Integer):String;
begin
 {}
 Result:=ErrorToString(ErrorCode);
end;

{==============================================================================}

function BooleanToString(Value:Boolean):String;
begin
 {}
 if Value then
  begin
   Result:='True';
  end
 else
  begin
   Result:='False';
  end;  
end;

{==============================================================================}

function CPUArchToString(CPUArch:LongWord):String;
begin
 {}
 Result:='CPU_ARCH_UNKNOWN';
 
 case CPUArch of
  CPU_ARCH_ARM32:Result:='CPU_ARCH_ARM32';
  CPU_ARCH_ARM64:Result:='CPU_ARCH_ARM64';
 end;
end;

{==============================================================================}

function CPUTypeToString(CPUType:LongWord):String;
begin
 {}
 Result:='CPU_TYPE_UNKNOWN';
 
 case CPUType of
  CPU_TYPE_ARMV6:Result:='CPU_TYPE_ARMV6';
  CPU_TYPE_ARMV7:Result:='CPU_TYPE_ARMV7';
  CPU_TYPE_ARMV8:Result:='CPU_TYPE_ARMV8';
 end;
end;

{==============================================================================}

function CPUModelToString(CPUModel:LongWord):String;
begin
 {}
 Result:='CPU_MODEL_UNKNOWN';
 
 case CPUModel of
  CPU_MODEL_ARM1176JZFS:Result:='CPU_MODEL_ARM1176JZFS';
  CPU_MODEL_CORTEX_A5:Result:='CPU_MODEL_CORTEX_A5';
  CPU_MODEL_CORTEX_A7:Result:='CPU_MODEL_CORTEX_A7';
  CPU_MODEL_CORTEX_A8:Result:='CPU_MODEL_CORTEX_A8';
  CPU_MODEL_CORTEX_A9:Result:='CPU_MODEL_CORTEX_A9';
  CPU_MODEL_CORTEX_A15:Result:='CPU_MODEL_CORTEX_A15';
  CPU_MODEL_CORTEX_A17:Result:='CPU_MODEL_CORTEX_A17';
  CPU_MODEL_CORTEX_A53:Result:='CPU_MODEL_CORTEX_A53';
  CPU_MODEL_CORTEX_A57:Result:='CPU_MODEL_CORTEX_A57';
  CPU_MODEL_CORTEX_A72:Result:='CPU_MODEL_CORTEX_A72';
 end;
end;

{==============================================================================}

function CPUIDToString(CPUID:LongWord):String;
begin
 {}
 Result:='';
 
 case CPUID of
  CPU_ID_0:Result:='CPU_ID_0';
  CPU_ID_1:Result:='CPU_ID_1';
  CPU_ID_2:Result:='CPU_ID_2';
  CPU_ID_3:Result:='CPU_ID_3';
  CPU_ID_4:Result:='CPU_ID_4';
  CPU_ID_5:Result:='CPU_ID_5';
  CPU_ID_6:Result:='CPU_ID_6';
  CPU_ID_7:Result:='CPU_ID_7';
  CPU_ID_8:Result:='CPU_ID_8';
  CPU_ID_9:Result:='CPU_ID_9';
  CPU_ID_10:Result:='CPU_ID_10';
  CPU_ID_11:Result:='CPU_ID_11';
  CPU_ID_12:Result:='CPU_ID_12';
  CPU_ID_13:Result:='CPU_ID_13';
  CPU_ID_14:Result:='CPU_ID_14';
  CPU_ID_15:Result:='CPU_ID_15';
  CPU_ID_16:Result:='CPU_ID_16';
  CPU_ID_17:Result:='CPU_ID_17';
  CPU_ID_18:Result:='CPU_ID_18';
  CPU_ID_19:Result:='CPU_ID_19';
  CPU_ID_20:Result:='CPU_ID_20';
  CPU_ID_21:Result:='CPU_ID_21';
  CPU_ID_22:Result:='CPU_ID_22';
  CPU_ID_23:Result:='CPU_ID_23';
  CPU_ID_24:Result:='CPU_ID_24';
  CPU_ID_25:Result:='CPU_ID_25';
  CPU_ID_26:Result:='CPU_ID_26';
  CPU_ID_27:Result:='CPU_ID_27';
  CPU_ID_28:Result:='CPU_ID_28';
  CPU_ID_29:Result:='CPU_ID_29';
  CPU_ID_30:Result:='CPU_ID_30';
  CPU_ID_31:Result:='CPU_ID_31';
  
  CPU_ID_ALL:Result:='CPU_ID_ALL';
 end;
end;

{==============================================================================}

function CPUGroupToString(CPUGroup:LongWord):String;
begin
 {}
 Result:='';
 
 case CPUGroup of
  CPU_GROUP_0:Result:='CPU_GROUP_0';
  CPU_GROUP_1:Result:='CPU_GROUP_1';
  CPU_GROUP_2:Result:='CPU_GROUP_2';
  CPU_GROUP_3:Result:='CPU_GROUP_3';
  CPU_GROUP_4:Result:='CPU_GROUP_4';
  CPU_GROUP_5:Result:='CPU_GROUP_5';
  CPU_GROUP_6:Result:='CPU_GROUP_6';
  CPU_GROUP_7:Result:='CPU_GROUP_7';
  CPU_GROUP_8:Result:='CPU_GROUP_8';
  CPU_GROUP_9:Result:='CPU_GROUP_9';
  CPU_GROUP_10:Result:='CPU_GROUP_10';
  CPU_GROUP_11:Result:='CPU_GROUP_11';
  CPU_GROUP_12:Result:='CPU_GROUP_12';
  CPU_GROUP_13:Result:='CPU_GROUP_13';
  CPU_GROUP_14:Result:='CPU_GROUP_14';
  CPU_GROUP_15:Result:='CPU_GROUP_15';
  CPU_GROUP_16:Result:='CPU_GROUP_16';
  CPU_GROUP_17:Result:='CPU_GROUP_17';
  CPU_GROUP_18:Result:='CPU_GROUP_18';
  CPU_GROUP_19:Result:='CPU_GROUP_19';
  CPU_GROUP_20:Result:='CPU_GROUP_20';
  CPU_GROUP_21:Result:='CPU_GROUP_21';
  CPU_GROUP_22:Result:='CPU_GROUP_22';
  CPU_GROUP_23:Result:='CPU_GROUP_23';
  CPU_GROUP_24:Result:='CPU_GROUP_24';
  CPU_GROUP_25:Result:='CPU_GROUP_25';
  CPU_GROUP_26:Result:='CPU_GROUP_26';
  CPU_GROUP_27:Result:='CPU_GROUP_27';
  CPU_GROUP_28:Result:='CPU_GROUP_28';
  CPU_GROUP_29:Result:='CPU_GROUP_29';
  CPU_GROUP_30:Result:='CPU_GROUP_30';
  CPU_GROUP_31:Result:='CPU_GROUP_31';
  
  CPU_GROUP_ALL:Result:='CPU_GROUP_ALL';
 end;
end;

{==============================================================================}

function FPUTypeToString(FPUType:LongWord):String;
begin
 {}
 Result:='FPU_TYPE_UNKNOWN';
 
 case FPUType of
  FPU_TYPE_SOFT:Result:='FPU_TYPE_SOFT';
  FPU_TYPE_VFPV2:Result:='FPU_TYPE_VFPV2';
  FPU_TYPE_VFPV3:Result:='FPU_TYPE_VFPV3';
  FPU_TYPE_VFPV4:Result:='FPU_TYPE_VFPV4';
 end;
end;

{==============================================================================}

function GPUTypeToString(GPUType:LongWord):String;
begin
 {}
 Result:='GPU_TYPE_UNKNOWN';
 
 case GPUType of
  GPU_TYPE_VC4:Result:='GPU_TYPE_VC4';
  GPU_TYPE_MALI400:Result:='GPU_TYPE_MALI400';
  GPU_TYPE_MALI450:Result:='GPU_TYPE_MALI450';
  GPU_TYPE_GC880:Result:='GPU_TYPE_GC880';
  GPU_TYPE_GC2000:Result:='GPU_TYPE_GC2000';
 end;
end;

{==============================================================================}

function CacheTypeToString(CacheType:LongWord):String;
begin
 {}
 Result:='CACHE_TYPE_NONE';
 
 case CacheType of
  CACHE_TYPE_DATA:Result:='CACHE_TYPE_DATA';
  CACHE_TYPE_INSTRUCTION:Result:='CACHE_TYPE_INSTRUCTION';
  CACHE_TYPE_SEPARATE:Result:='CACHE_TYPE_SEPARATE';
  CACHE_TYPE_UNIFIED:Result:='CACHE_TYPE_UNIFIED';
 end;
end;

{==============================================================================}

function BoardTypeToString(BoardType:LongWord):String;
begin
 {}
 Result:='BOARD_TYPE_UNKNOWN';
 
 case BoardType of
  BOARD_TYPE_RPIA:Result:='BOARD_TYPE_RPIA';
  BOARD_TYPE_RPIB:Result:='BOARD_TYPE_RPIB';
  BOARD_TYPE_RPI_COMPUTE:Result:='BOARD_TYPE_RPI_COMPUTE';
  BOARD_TYPE_RPIA_PLUS:Result:='BOARD_TYPE_RPIA_PLUS';
  BOARD_TYPE_RPIB_PLUS:Result:='BOARD_TYPE_RPIB_PLUS';
  BOARD_TYPE_RPI2B:Result:='BOARD_TYPE_RPI2B';
  BOARD_TYPE_RPI_ZERO:Result:='BOARD_TYPE_RPI_ZERO';
  BOARD_TYPE_BPI:Result:='BOARD_TYPE_BPI';
  BOARD_TYPE_BPRO:Result:='BOARD_TYPE_BPRO';
  BOARD_TYPE_BBB_REVC:Result:='BOARD_TYPE_BBB_REVC';
  BOARD_TYPE_CUBOX_I:Result:='BOARD_TYPE_CUBOX_I';
  BOARD_TYPE_HUMMINGBOARD:Result:='BOARD_TYPE_HUMMINGBOARD';
  BOARD_TYPE_CREATOR_CI20:Result:='BOARD_TYPE_CREATOR_CI20';
  BOARD_TYPE_PCDUINO1:Result:='BOARD_TYPE_PCDUINO1';
  BOARD_TYPE_PCDUINO2:Result:='BOARD_TYPE_PCDUINO2';
  BOARD_TYPE_PCDUINO3:Result:='BOARD_TYPE_PCDUINO3'; 
  BOARD_TYPE_ODROID_C1:Result:='BOARD_TYPE_ODROID_C1';
  BOARD_TYPE_ODROID_U2:Result:='BOARD_TYPE_ODROID_U2'; 
  BOARD_TYPE_ODROID_U3:Result:='BOARD_TYPE_ODROID_U3';  
  BOARD_TYPE_ODROID_XU3:Result:='BOARD_TYPE_ODROID_XU3'; 
  BOARD_TYPE_ODROID_XU4:Result:='BOARD_TYPE_ODROID_XU4'; 
  BOARD_TYPE_PC_X86:Result:='BOARD_TYPE_PC_X86'; 
  BOARD_TYPE_PC_X86_64:Result:='BOARD_TYPE_PC_X86_64'; 
  BOARD_TYPE_RPI3B:Result:='BOARD_TYPE_RPI3B';
  BOARD_TYPE_QEMUVPB:Result:='BOARD_TYPE_QEMUVPB';
  BOARD_TYPE_RPI_COMPUTE3:Result:='BOARD_TYPE_RPI_COMPUTE3';
  BOARD_TYPE_RPI_ZERO_W:Result:='BOARD_TYPE_RPI_ZERO_W';
 end;
end;

{==============================================================================}

function MachineTypeToString(MachineType:LongWord):String;
begin
 {}
 Result:='MACHINE_TYPE_UNKNOWN';
 
 case MachineType of
  MACHINE_TYPE_BCM2708:Result:='MACHINE_TYPE_BCM2708';
  MACHINE_TYPE_BCM2709:Result:='MACHINE_TYPE_BCM2709';
  MACHINE_TYPE_BCM2710:Result:='MACHINE_TYPE_BCM2710';
  MACHINE_TYPE_VERSATILEPB:Result:='MACHINE_TYPE_VERSATILEPB';
 end;
end;

{==============================================================================}

function PowerIDToString(PowerID:LongWord):String;
begin
 {}
 Result:='';
 
 case PowerID of
  POWER_ID_MMC0:Result:='POWER_ID_MMC0';
  POWER_ID_MMC1:Result:='POWER_ID_MMC1';
  POWER_ID_MMC2:Result:='POWER_ID_MMC2';
  POWER_ID_MMC3:Result:='POWER_ID_MMC3';
  POWER_ID_UART0:Result:='POWER_ID_UART0';
  POWER_ID_UART1:Result:='POWER_ID_UART1';
  POWER_ID_UART2:Result:='POWER_ID_UART2';
  POWER_ID_UART3:Result:='POWER_ID_UART3';
  POWER_ID_USB0:Result:='POWER_ID_USB0';
  POWER_ID_USB1:Result:='POWER_ID_USB1';
  POWER_ID_USB2:Result:='POWER_ID_USB2';
  POWER_ID_USB3:Result:='POWER_ID_USB3';
  POWER_ID_I2C0:Result:='POWER_ID_I2C0';
  POWER_ID_I2C1:Result:='POWER_ID_I2C1';
  POWER_ID_I2C2:Result:='POWER_ID_I2C2';
  POWER_ID_I2C3:Result:='POWER_ID_I2C3';
  POWER_ID_SPI0:Result:='POWER_ID_SPI0';
  POWER_ID_SPI1:Result:='POWER_ID_SPI1';
  POWER_ID_SPI2:Result:='POWER_ID_SPI2';
  POWER_ID_SPI3:Result:='POWER_ID_SPI3';
  POWER_ID_CCP2TX:Result:='POWER_ID_CCP2TX';
 end;
end;

{==============================================================================}

function PowerStateToString(PowerState:LongWord):String;
begin
 {}
 Result:='';
 
 case PowerState of
  POWER_STATE_OFF:Result:='POWER_STATE_OFF';
  POWER_STATE_ON:Result:='POWER_STATE_ON';
 end;
end;

{==============================================================================}

function ClockIDToString(ClockID:LongWord):String;
begin
 {}
 Result:='';
 
 case ClockID of
  CLOCK_ID_MMC0:Result:='CLOCK_ID_MMC0';
  CLOCK_ID_MMC1:Result:='CLOCK_ID_MMC1';
  CLOCK_ID_MMC2:Result:='CLOCK_ID_MMC2';
  CLOCK_ID_MMC3:Result:='CLOCK_ID_MMC3';
  CLOCK_ID_UART0:Result:='CLOCK_ID_UART0';
  CLOCK_ID_UART1:Result:='CLOCK_ID_UART1';
  CLOCK_ID_UART2:Result:='CLOCK_ID_UART2';
  CLOCK_ID_UART3:Result:='CLOCK_ID_UART3';
  CLOCK_ID_CPU:Result:='CLOCK_ID_CPU';
  CLOCK_ID_CORE:Result:='CLOCK_ID_CORE';
  CLOCK_ID_GPU:Result:='CLOCK_ID_GPU';
  CLOCK_ID_V3D:Result:='CLOCK_ID_V3D';
  CLOCK_ID_H264:Result:='CLOCK_ID_H264';
  CLOCK_ID_ISP:Result:='CLOCK_ID_ISP';
  CLOCK_ID_SDRAM:Result:='CLOCK_ID_SDRAM';
  CLOCK_ID_PIXEL:Result:='CLOCK_ID_PIXEL';
  CLOCK_ID_PWM0:Result:='CLOCK_ID_PWM0';
  CLOCK_ID_PWM1:Result:='CLOCK_ID_PWM1';
  CLOCK_ID_I2C0:Result:='CLOCK_ID_I2C0';
  CLOCK_ID_I2C1:Result:='CLOCK_ID_I2C1';
  CLOCK_ID_I2C2:Result:='CLOCK_ID_I2C2';
  CLOCK_ID_I2C3:Result:='CLOCK_ID_I2C3';
  CLOCK_ID_SPI0:Result:='CLOCK_ID_SPI0';
  CLOCK_ID_SPI1:Result:='CLOCK_ID_SPI1';
  CLOCK_ID_SPI2:Result:='CLOCK_ID_SPI2';
  CLOCK_ID_SPI3:Result:='CLOCK_ID_SPI3';
 end;
end;

{==============================================================================}

function ClockStateToString(ClockState:LongWord):String;
begin
 {}
 Result:='';
 
 case ClockState of
 CLOCK_STATE_OFF:Result:='CLOCK_STATE_OFF';
 CLOCK_STATE_ON:Result:='CLOCK_STATE_ON';
 end;
end;

{==============================================================================}

function TurboIDToString(TurboID:LongWord):String;
begin
 {}
 Result:='';
 
 case TurboID of
  TURBO_ID_SOC:Result:='TURBO_ID_SOC';
 end;
end;

{==============================================================================}

function VoltageIDToString(VoltageID:LongWord):String;
begin
 {}
 Result:='';
 
 case VoltageID of
  VOLTAGE_ID_CORE:Result:='VOLTAGE_ID_CORE';
  VOLTAGE_ID_SDRAM_C:Result:='VOLTAGE_ID_SDRAM_C';
  VOLTAGE_ID_SDRAM_P:Result:='VOLTAGE_ID_SDRAM_P';
  VOLTAGE_ID_SDRAM_I:Result:='VOLTAGE_ID_SDRAM_I';
 end;
end;

{==============================================================================}

function TemperatureIDToString(TemperatureID:LongWord):String;
begin
 {}
 Result:='';
 
 case TemperatureID of
  TEMPERATURE_ID_SOC:Result:='TEMPERATURE_ID_SOC';
 end;
end;

{==============================================================================}

function ColorFormatToBytes(Format:LongWord):LongWord;
{Convert a color format constant into the number of bytes per pixel}
{Format: The color format constant to get bytes for (eg COLOR_FORMAT_ARGB32)}
{Return: The number of bytes required for each pixel}
begin
 {}
 Result:=0;
 
 case Format of
  {RGB/BGR Formats}
  COLOR_FORMAT_ARGB32:Result:=4;
  COLOR_FORMAT_ABGR32:Result:=4;
  COLOR_FORMAT_RGBA32:Result:=4;
  COLOR_FORMAT_BGRA32:Result:=4;
  COLOR_FORMAT_URGB32:Result:=4;
  COLOR_FORMAT_UBGR32:Result:=4;
  COLOR_FORMAT_RGBU32:Result:=4;
  COLOR_FORMAT_BGRU32:Result:=4;
  COLOR_FORMAT_RGB24:Result:=3;
  COLOR_FORMAT_BGR24:Result:=3;
  COLOR_FORMAT_RGB16:Result:=2;
  COLOR_FORMAT_BGR16:Result:=2;
  COLOR_FORMAT_RGB15:Result:=2;
  COLOR_FORMAT_BGR15:Result:=2;
  COLOR_FORMAT_RGB8:Result:=1;
  COLOR_FORMAT_BGR8:Result:=1;
  {Grayscale Formats}
  COLOR_FORMAT_GRAY16:Result:=2;
  COLOR_FORMAT_GRAY8:Result:=1;
  {Index Formats}
  COLOR_FORMAT_INDEX16:Result:=2;
  COLOR_FORMAT_INDEX8:Result:=1;
 end;
end;

{==============================================================================}

function ColorFormatToString(Format:LongWord):String;
begin
 {}
 Result:='COLOR_FORMAT_UNKNOWN';
 
 case Format of
  {RGB/BGR Formats}
  COLOR_FORMAT_ARGB32:Result:='COLOR_FORMAT_ARGB32';
  COLOR_FORMAT_ABGR32:Result:='COLOR_FORMAT_ABGR32';
  COLOR_FORMAT_RGBA32:Result:='COLOR_FORMAT_RGBA32';
  COLOR_FORMAT_BGRA32:Result:='COLOR_FORMAT_BGRA32';
  COLOR_FORMAT_URGB32:Result:='COLOR_FORMAT_URGB32';
  COLOR_FORMAT_UBGR32:Result:='COLOR_FORMAT_UBGR32';
  COLOR_FORMAT_RGBU32:Result:='COLOR_FORMAT_RGBU32';
  COLOR_FORMAT_BGRU32:Result:='COLOR_FORMAT_BGRU32';
  COLOR_FORMAT_RGB24:Result:='COLOR_FORMAT_RGB24';
  COLOR_FORMAT_BGR24:Result:='COLOR_FORMAT_BGR24';
  COLOR_FORMAT_RGB16:Result:='COLOR_FORMAT_RGB16';
  COLOR_FORMAT_BGR16:Result:='COLOR_FORMAT_BGR16';
  COLOR_FORMAT_RGB15:Result:='COLOR_FORMAT_RGB15';
  COLOR_FORMAT_BGR15:Result:='COLOR_FORMAT_BGR15';
  COLOR_FORMAT_RGB8:Result:='COLOR_FORMAT_RGB8';
  COLOR_FORMAT_BGR8:Result:='COLOR_FORMAT_BGR8';
  {Grayscale Formats}
  COLOR_FORMAT_GRAY16:Result:='COLOR_FORMAT_GRAY16';
  COLOR_FORMAT_GRAY8:Result:='COLOR_FORMAT_GRAY8';
  {Index Formats}
  COLOR_FORMAT_INDEX16:Result:='COLOR_FORMAT_INDEX16';
  COLOR_FORMAT_INDEX8:Result:='COLOR_FORMAT_INDEX8'; 
 end;
end;

{==============================================================================}

procedure ColorDefaultToFormat(Format,Color:LongWord;Dest:Pointer;Reverse:Boolean); inline;
{Convert a color value in the default format to the specified format}
{Format: The color format to convert to (eg COLOR_FORMAT_RGB24)}
{Color: The color to be converted (Must be in the default format - See: COLOR_FORMAT_DEFAULT)}
{Dest: Pointer to the destination buffer for the converted color}
{Reverse: If true then reverse the byte order of the destination after conversion}
{$IFDEF FPC_BIG_ENDIAN}
begin
 {}
 {Check Dest}
 if Dest = nil then Exit;
 
 {Check Format}
 if Format = COLOR_FORMAT_DEFAULT then {COLOR_FORMAT_ARGB32}
  begin
   if not(Reverse) then PLongWord(Dest)^:=Color else PLongWord(Dest)^:=SwapEndian(Color);
  end
 else
  begin 
   {Check Format}
   //To Do //Continuing 
  end;
end; 
{$ELSE FPC_BIG_ENDIAN}
begin
 {}
 {Check Dest}
 if Dest = nil then Exit;
 
 {Check Format}
 if Format = COLOR_FORMAT_DEFAULT then {COLOR_FORMAT_ARGB32}
  begin
   if not(Reverse) then PLongWord(Dest)^:=Color else PLongWord(Dest)^:=SwapEndian(Color);
  end
 else
  begin 
   {Check Format}
   case Format of
    {32bit}
    COLOR_FORMAT_DEFAULT,COLOR_FORMAT_URGB32:begin {COLOR_FORMAT_ARGB32}
      if not(Reverse) then PLongWord(Dest)^:=Color else PLongWord(Dest)^:=SwapEndian(Color);
     end;
    COLOR_FORMAT_ABGR32,COLOR_FORMAT_UBGR32:begin
      if not(Reverse) then 
       begin
        PLongWord(Dest)^:=(Color and $FF00FF00) or ((Color and $00FF0000) shr 16) or ((Color and $000000FF) shl 16);
       end
      else
       begin
        PLongWord(Dest)^:=SwapEndian((Color and $FF00FF00) or ((Color and $00FF0000) shr 16) or ((Color and $000000FF) shl 16));
       end;
     end;
    COLOR_FORMAT_RGBA32,COLOR_FORMAT_RGBU32:begin
      if not(Reverse) then 
       begin
        PLongWord(Dest)^:=((Color and $00FFFFFF) shl 8) or ((Color and $FF000000) shr 24);
       end
      else
       begin
        PLongWord(Dest)^:=SwapEndian(((Color and $00FFFFFF) shl 8) or ((Color and $FF000000) shr 24));
       end;
     end;
    COLOR_FORMAT_BGRA32,COLOR_FORMAT_BGRU32:begin
      if not(Reverse) then 
       begin
        PLongWord(Dest)^:=((Color and $000000FF) shl 24) or ((Color and $0000FF00) shl 8) or ((Color and $00FF0000) shr 8) or ((Color and $FF000000) shr 24);
       end
      else
       begin
        PLongWord(Dest)^:=SwapEndian(((Color and $000000FF) shl 24) or ((Color and $0000FF00) shl 8) or ((Color and $00FF0000) shr 8) or ((Color and $FF000000) shr 24));
       end;
     end;
    {24bit}
    COLOR_FORMAT_RGB24:begin
      {Value:=Color and $00FFFFFF;}
      {System.Move(Value,Dest^,3);}
      if not(Reverse) then 
       begin
        PByte(Dest + 0)^:=(Color and $000000FF);
        PByte(Dest + 1)^:=(Color and $0000FF00) shr 8;
        PByte(Dest + 2)^:=(Color and $00FF0000) shr 16;
       end
      else
       begin
        PByte(Dest + 0)^:=(Color and $00FF0000) shr 16;
        PByte(Dest + 1)^:=(Color and $0000FF00) shr 8;
        PByte(Dest + 2)^:=(Color and $000000FF);
       end;
     end;
    COLOR_FORMAT_BGR24:begin
      {Value:=(Color and $0000FF00) or ((Color and $00FF0000) shr 16) or ((Color and $000000FF) shl 16);}
      {System.Move(Value,Dest^,3);}
      if not(Reverse) then 
       begin
        PByte(Dest + 0)^:=(Color and $00FF0000) shr 16;
        PByte(Dest + 1)^:=(Color and $0000FF00) shr 8;
        PByte(Dest + 2)^:=(Color and $000000FF);
       end
      else
       begin
        PByte(Dest + 0)^:=(Color and $000000FF);
        PByte(Dest + 1)^:=(Color and $0000FF00) shr 8;
        PByte(Dest + 2)^:=(Color and $00FF0000) shr 16;
       end;
     end;
    {16bit}
    COLOR_FORMAT_RGB16:begin
      if not(Reverse) then 
       begin
        PWord(Dest)^:=((Color and $00F80000) shr 8) or ((Color and $0000FC00) shr 5) or ((Color and $000000F8) shr 3);
       end
      else
       begin
        PWord(Dest)^:=SwapEndian(Word(((Color and $00F80000) shr 8) or ((Color and $0000FC00) shr 5) or ((Color and $000000F8) shr 3)));
       end; 
     end;
    COLOR_FORMAT_BGR16:begin
      if not(Reverse) then 
       begin
        PWord(Dest)^:=((Color and $000000F8) shl 8) or ((Color and $0000FC00) shr 5) or ((Color and $00F80000) shr 19);
       end
      else
       begin
        PWord(Dest)^:=SwapEndian(Word(((Color and $000000F8) shl 8) or ((Color and $0000FC00) shr 5) or ((Color and $00F80000) shr 19)));
       end; 
     end;
    COLOR_FORMAT_RGB15:begin
      if not(Reverse) then 
       begin
        PWord(Dest)^:=((Color and $00F80000) shr 9) or ((Color and $0000F800) shr 6) or ((Color and $000000F8) shr 3);
       end
      else
       begin
        PWord(Dest)^:=SwapEndian(Word(((Color and $00F80000) shr 9) or ((Color and $0000F800) shr 6) or ((Color and $000000F8) shr 3)));
       end;
     end;
    COLOR_FORMAT_BGR15:begin
      if not(Reverse) then 
       begin
        PWord(Dest)^:=((Color and $000000F8) shl 7) or ((Color and $0000F800) shr 6) or ((Color and $00F80000) shr 19);
       end
      else
       begin
        PWord(Dest)^:=SwapEndian(Word(((Color and $000000F8) shl 7) or ((Color and $0000F800) shr 6) or ((Color and $00F80000) shr 19)));
       end;
     end;
    COLOR_FORMAT_GRAY16,COLOR_FORMAT_INDEX16:begin
      {Luma approximation (Red * 0.299 + Green * 0.587 + Blue * 0.114)}
      if not(Reverse) then 
       begin
        PWord(Dest)^:=((Integer((Color and $00FF0000) shr 16) * 19588) + (Integer((Color and $0000FF00) shr 8) * 38445) + (Integer(Color and $000000FF) * 7503)) div 256;
       end
      else
       begin
        PWord(Dest)^:=SwapEndian(Word(((Integer((Color and $00FF0000) shr 16) * 19588) + (Integer((Color and $0000FF00) shr 8) * 38445) + (Integer(Color and $000000FF) * 7503)) div 256));
       end;
     end;
    {8bit}
    COLOR_FORMAT_RGB8:begin
      {No Reverse}
      PByte(Dest)^:=((Color and $00E00000) shr 16) or ((Color and $0000E000) shr 11) or ((Color and $000000C0) shr 6);
     end;
    COLOR_FORMAT_BGR8:begin
      {No Reverse}
      PByte(Dest)^:=(Color and $000000C0) or ((Color and $0000E000) shr 10) or ((Color and $00E00000) shr 21);
     end;
    COLOR_FORMAT_GRAY8,COLOR_FORMAT_INDEX8:begin
      {No Reverse}
      {Luma approximation (Red * 0.299 + Green * 0.587 + Blue * 0.114)}
      PByte(Dest)^:=((Integer((Color and $00FF0000) shr 16) * 77) + (Integer((Color and $0000FF00) shr 8) * 150) + (Integer(Color and $000000FF) * 29)) div 256;
     end;
   end;
  end;
end;
{$ENDIF FPC_BIG_ENDIAN}
{==============================================================================}

procedure ColorFormatToDefault(Format:LongWord;Source:Pointer;var Color:Longword;Reverse:Boolean); inline;
{Convert a color value in the specified format to the default format}
{Format: The color format to convert from (eg COLOR_FORMAT_RGB24)}
{Source: Pointer to the source buffer for the color to convert}
{Color: The converted color (Will be returned in the default format - See: COLOR_FORMAT_DEFAULT)}
{Reverse: If true then reverse the byte order of the color after conversion}
{$IFDEF FPC_BIG_ENDIAN}
begin
 {}
 {Check Sourc}
 if Source = nil then
  begin
   Color:=COLOR_NONE;
   Exit;
  end;

 {Check Format}
 if Format = COLOR_FORMAT_DEFAULT then {COLOR_FORMAT_ARGB32}
  begin
   if not(Reverse) then Color:=PLongWord(Source)^ else Color:=SwapEndian(PLongWord(Source)^);
  end
 else
  begin 
   {Check Format}
   //To Do //Continuing 
  end; 
end; 
{$ELSE FPC_BIG_ENDIAN}
begin
 {}
 {Check Sourc}
 if Source = nil then
  begin
   Color:=COLOR_NONE;
   Exit;
  end;
  
 {Check Format}
 if Format = COLOR_FORMAT_DEFAULT then {COLOR_FORMAT_ARGB32}
  begin
   if not(Reverse) then Color:=PLongWord(Source)^ else Color:=SwapEndian(PLongWord(Source)^);
  end
 else
  begin 
   {Check Format}
   case Format of
    {32bit}
    COLOR_FORMAT_DEFAULT:begin {COLOR_FORMAT_ARGB32}
      if not(Reverse) then Color:=PLongWord(Source)^ else Color:=SwapEndian(PLongWord(Source)^);
     end;
    COLOR_FORMAT_ABGR32:begin
      if not(Reverse) then 
       begin
        Color:=(PLongWord(Source)^ and $FF00FF00) or ((PLongWord(Source)^ and $00FF0000) shr 16) or ((PLongWord(Source)^ and $000000FF) shl 16);
       end
      else
       begin
        Color:=SwapEndian((PLongWord(Source)^ and $FF00FF00) or ((PLongWord(Source)^ and $00FF0000) shr 16) or ((PLongWord(Source)^ and $000000FF) shl 16));
       end;
     end;
    COLOR_FORMAT_RGBA32:begin
      if not(Reverse) then 
       begin
        Color:=((PLongWord(Source)^ and $FFFFFF00) shr 8) or ((PLongWord(Source)^ and $000000FF) shl 24);
       end
      else
       begin
        Color:=SwapEndian(((PLongWord(Source)^ and $FFFFFF00) shr 8) or ((PLongWord(Source)^ and $000000FF) shl 24));
       end;
     end;
    COLOR_FORMAT_BGRA32:begin
      if not(Reverse) then 
       begin
        Color:=((PLongWord(Source)^ and $FF000000) shr 24) or ((PLongWord(Source)^ and $00FF0000) shr 8) or ((PLongWord(Source)^ and $0000FF00) shl 8) or ((PLongWord(Source)^ and $000000FF) shl 24);
       end
      else
       begin
        Color:=SwapEndian(((PLongWord(Source)^ and $FF000000) shr 24) or ((PLongWord(Source)^ and $00FF0000) shr 8) or ((PLongWord(Source)^ and $0000FF00) shl 8) or ((PLongWord(Source)^ and $000000FF) shl 24));
       end;
     end;
    COLOR_FORMAT_URGB32:begin
      if not(Reverse) then Color:=($FF000000 or PLongWord(Source)^) else Color:=SwapEndian($FF000000 or PLongWord(Source)^);
     end;
    COLOR_FORMAT_UBGR32:begin
      if not(Reverse) then 
       begin
        Color:=$FF000000 or (PLongWord(Source)^ and $0000FF00) or ((PLongWord(Source)^ and $00FF0000) shr 16) or ((PLongWord(Source)^ and $000000FF) shl 16);
       end
      else
       begin
        Color:=SwapEndian($FF000000 or (PLongWord(Source)^ and $0000FF00) or ((PLongWord(Source)^ and $00FF0000) shr 16) or ((PLongWord(Source)^ and $000000FF) shl 16));
       end;
     end;
    COLOR_FORMAT_RGBU32:begin
      if not(Reverse) then 
       begin
        Color:=$FF000000 or ((PLongWord(Source)^ and $FFFFFF00) shr 8);
       end
      else
       begin
        Color:=SwapEndian($FF000000 or ((PLongWord(Source)^ and $FFFFFF00) shr 8));
       end;
     end;
    COLOR_FORMAT_BGRU32:begin
      if not(Reverse) then 
       begin
        Color:=$FF000000 or ((PLongWord(Source)^ and $FF000000) shr 24) or ((PLongWord(Source)^ and $00FF0000) shr 8) or ((PLongWord(Source)^ and $0000FF00) shl 8);
       end
      else
       begin
        Color:=SwapEndian($FF000000 or ((PLongWord(Source)^ and $FF000000) shr 24) or ((PLongWord(Source)^ and $00FF0000) shr 8) or ((PLongWord(Source)^ and $0000FF00) shl 8));
       end;
     end;
    {24bit}
    COLOR_FORMAT_RGB24:begin
      if not(Reverse) then 
       begin
        Color:=$FF000000 or (PByte(Source + 0)^) or (PByte(Source + 1)^ shl 8) or (PByte(Source + 2)^ shl 16);
       end
      else
       begin
        Color:=SwapEndian(LongWord($FF000000 or (PByte(Source + 0)^) or (PByte(Source + 1)^ shl 8) or (PByte(Source + 2)^ shl 16)));
       end;
     end;
    COLOR_FORMAT_BGR24:begin
      if not(Reverse) then 
       begin
        Color:=$FF000000 or (PByte(Source + 0)^ shl 16) or (PByte(Source + 1)^ shl 8) or (PByte(Source + 2)^);
       end
      else
       begin
        Color:=SwapEndian(LongWord($FF000000 or (PByte(Source + 0)^ shl 16) or (PByte(Source + 1)^ shl 8) or (PByte(Source + 2)^)));
       end;
     end;
    {16bit}
    COLOR_FORMAT_RGB16:begin
      if not(Reverse) then 
       begin
        Color:=$FF000000 or ((PWord(Source)^ and $F800) shl 8) or ((PWord(Source)^ and $07E0) shl 5) or ((PWord(Source)^ and $001F) shl 3);
       end
      else
       begin
        Color:=SwapEndian(LongWord($FF000000 or ((PWord(Source)^ and $F800) shl 8) or ((PWord(Source)^ and $07E0) shl 5) or ((PWord(Source)^ and $001F) shl 3)));
       end;
     end;
    COLOR_FORMAT_BGR16:begin
      if not(Reverse) then 
       begin
        Color:=$FF000000 or ((PWord(Source)^ and $001F) shl 19) or ((PWord(Source)^ and $07E0) shl 5) or ((PWord(Source)^ and $F800) shr 8);
       end
      else
       begin
        Color:=SwapEndian(LongWord($FF000000 or ((PWord(Source)^ and $001F) shl 19) or ((PWord(Source)^ and $07E0) shl 5) or ((PWord(Source)^ and $F800) shr 8)));
       end;
     end;
    COLOR_FORMAT_RGB15:begin
      if not(Reverse) then 
       begin
        Color:=$FF000000 or ((PWord(Source)^ and $7C00) shl 9) or ((PWord(Source)^ and $03E0) shl 6) or ((PWord(Source)^ and $001F) shl 3);
       end
      else
       begin
        Color:=SwapEndian(LongWord($FF000000 or ((PWord(Source)^ and $7C00) shl 9) or ((PWord(Source)^ and $03E0) shl 6) or ((PWord(Source)^ and $001F) shl 3)));
       end;
     end;
    COLOR_FORMAT_BGR15:begin
      if not(Reverse) then 
       begin
        Color:=$FF000000 or ((PWord(Source)^ and $001F) shl 19) or ((PWord(Source)^ and $03E0) shl 6) or ((PWord(Source)^ and $7C00) shr 7);
       end
      else
       begin
        Color:=SwapEndian(LongWord($FF000000 or ((PWord(Source)^ and $001F) shl 19) or ((PWord(Source)^ and $03E0) shl 6) or ((PWord(Source)^ and $7C00) shr 7)));
       end;
     end;
    COLOR_FORMAT_GRAY16,COLOR_FORMAT_INDEX16:begin
  {COLOR_FORMAT_ARGB32}    
      if not(Reverse) then 
       begin
        //To Do //Continuing 
       end
      else
       begin
        //To Do //Continuing 
       end;
     end;
    {8bit}
    COLOR_FORMAT_RGB8:begin
  {COLOR_FORMAT_ARGB32}    
      {No Reverse}
      //To Do //Continuing 
     end;
    COLOR_FORMAT_BGR8:begin
  {COLOR_FORMAT_ARGB32}    
      {No Reverse}
      //To Do //Continuing 
     end;
    COLOR_FORMAT_GRAY8,COLOR_FORMAT_INDEX8:begin
  {COLOR_FORMAT_ARGB32}    
      {No Reverse}
      //To Do //Continuing 
     end;
   end;
  end;  
end;
{$ENDIF FPC_BIG_ENDIAN}
{==============================================================================}

procedure ColorDefaultAltToFormat(Format,Color:LongWord;Dest:Pointer;Reverse:Boolean); {Not inline}
{Convert a color value in the default format to the specified format (Alternate)}
{Format: The color format to convert to (eg COLOR_FORMAT_RGB24)}
{Color: The color to be converted (Must be in the default format - See: COLOR_FORMAT_DEFAULT)}
{Dest: Pointer to the destination buffer for the converted color}
{Reverse: If true then reverse the byte order of the destination before conversion (Differs from ColorDefaultToFormat)}
begin
 {}
 if not(Reverse) then
  begin
   ColorDefaultToFormat(Format,Color,Dest,False);
  end
 else
  begin
   ColorDefaultToFormat(Format,SwapEndian(Color),Dest,False);
  end;
end;

{==============================================================================}

procedure ColorFormatAltToDefault(Format:LongWord;Source:Pointer;var Color:Longword;Reverse:Boolean); inline;
{Convert a color value in the specified format to the default format (Alternate)}
{Format: The color format to convert from (eg COLOR_FORMAT_RGB24)}
{Source: Pointer to the source buffer for the color to convert}
{Color: The converted color (Will be returned in the default format - See: COLOR_FORMAT_DEFAULT)}
{Reverse: If true then reverse the byte order of the source before conversion (Differs from ColorFormatToDefault)}
var
 Value:LongWord;
{$IFDEF FPC_BIG_ENDIAN}
begin
 {}
 {Check Sourc}
 if Source = nil then
  begin
   Color:=COLOR_NONE;
   Exit;
  end;

 {Check Format}
 if Format = COLOR_FORMAT_DEFAULT then {COLOR_FORMAT_ARGB32}
  begin
   if not(Reverse) then Color:=PLongWord(Source)^ else Color:=SwapEndian(PLongWord(Source)^);
  end
 else
  begin 
   {Check Format}
   //To Do //Continuing 
  end; 
end; 
{$ELSE FPC_BIG_ENDIAN}
begin
 {}
 {Check Sourc}
 if Source = nil then
  begin
   Color:=COLOR_NONE;
   Exit;
  end;
  
 {Check Format}
 if Format = COLOR_FORMAT_DEFAULT then {COLOR_FORMAT_ARGB32}
  begin
   if not(Reverse) then Color:=PLongWord(Source)^ else Color:=SwapEndian(PLongWord(Source)^);
  end
 else
  begin 
   {Check Format}
   case Format of
    {32bit}
    COLOR_FORMAT_DEFAULT:begin {COLOR_FORMAT_ARGB32}
      if not(Reverse) then Color:=PLongWord(Source)^ else Color:=SwapEndian(PLongWord(Source)^);
     end;
    COLOR_FORMAT_ABGR32:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PLongWord(Source)^ else Value:=SwapEndian(PLongWord(Source)^);
      Color:=(Value and $FF00FF00) or ((Value and $00FF0000) shr 16) or ((Value and $000000FF) shl 16);
     end;
    COLOR_FORMAT_RGBA32:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PLongWord(Source)^ else Value:=SwapEndian(PLongWord(Source)^);
      Color:=((Value and $FFFFFF00) shr 8) or ((Value and $000000FF) shl 24);
     end;
    COLOR_FORMAT_BGRA32:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PLongWord(Source)^ else Value:=SwapEndian(PLongWord(Source)^);
      Color:=((Value and $FF000000) shr 24) or ((Value and $00FF0000) shr 8) or ((Value and $0000FF00) shl 8) or ((Value and $000000FF) shl 24);
     end;
    COLOR_FORMAT_URGB32:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PLongWord(Source)^ else Value:=SwapEndian(PLongWord(Source)^);
      Color:=$FF000000 or Value;
     end;
    COLOR_FORMAT_UBGR32:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PLongWord(Source)^ else Value:=SwapEndian(PLongWord(Source)^);
      Color:=$FF000000 or (Value and $0000FF00) or ((Value and $00FF0000) shr 16) or ((Value and $000000FF) shl 16);
     end;
    COLOR_FORMAT_RGBU32:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PLongWord(Source)^ else Value:=SwapEndian(PLongWord(Source)^);
      Color:=$FF000000 or ((Value and $FFFFFF00) shr 8);
     end;
    COLOR_FORMAT_BGRU32:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PLongWord(Source)^ else Value:=SwapEndian(PLongWord(Source)^);
      Color:=$FF000000 or ((Value and $FF000000) shr 24) or ((Value and $00FF0000) shr 8) or ((Value and $0000FF00) shl 8);
     end;
    {24bit}
    COLOR_FORMAT_RGB24:begin
      {Opposite to normal}
      if not(Reverse) then 
       begin
        Color:=$FF000000 or (PByte(Source + 0)^) or (PByte(Source + 1)^ shl 8) or (PByte(Source + 2)^ shl 16);
       end
      else
       begin
        Color:=$FF000000 or (PByte(Source + 2)^) or (PByte(Source + 1)^ shl 8) or (PByte(Source + 0)^ shl 16);
       end;
     end;
    COLOR_FORMAT_BGR24:begin
      {Opposite to normal}
      if not(Reverse) then 
       begin
        Color:=$FF000000 or (PByte(Source + 0)^ shl 16) or (PByte(Source + 1)^ shl 8) or (PByte(Source + 2)^);
       end
      else
       begin
        Color:=$FF000000 or (PByte(Source + 2)^ shl 16) or (PByte(Source + 1)^ shl 8) or (PByte(Source + 0)^);
       end;
     end;
    {16bit}
    COLOR_FORMAT_RGB16:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PWord(Source)^ else Value:=SwapEndian(PWord(Source)^);
      Color:=$FF000000 or ((Value and $F800) shl 8) or ((Value and $07E0) shl 5) or ((Value and $001F) shl 3);
     end;
    COLOR_FORMAT_BGR16:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PWord(Source)^ else Value:=SwapEndian(PWord(Source)^);
      Color:=$FF000000 or ((Value and $001F) shl 19) or ((Value and $07E0) shl 5) or ((Value and $F800) shr 8);
     end;
    COLOR_FORMAT_RGB15:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PWord(Source)^ else Value:=SwapEndian(PWord(Source)^);
      Color:=$FF000000 or ((Value and $7C00) shl 9) or ((Value and $03E0) shl 6) or ((Value and $001F) shl 3);
     end;
    COLOR_FORMAT_BGR15:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PWord(Source)^ else Value:=SwapEndian(PWord(Source)^);
      Color:=$FF000000 or ((Value and $001F) shl 19) or ((Value and $03E0) shl 6) or ((Value and $7C00) shr 7);
     end;
    COLOR_FORMAT_GRAY16,COLOR_FORMAT_INDEX16:begin
      {Swap before conversion}
      if not(Reverse) then Value:=PWord(Source)^ else Value:=SwapEndian(PWord(Source)^);
      //To Do //Continuing  
     end;
    {8bit}
    COLOR_FORMAT_RGB8:begin
      {No Reverse}
      //To Do //Continuing  
     end;
    COLOR_FORMAT_BGR8:begin
      {No Reverse}
      //To Do //Continuing  
     end;
    COLOR_FORMAT_GRAY8,COLOR_FORMAT_INDEX8:begin
      {No Reverse}
      //To Do //Continuing  
     end;
   end;
  end; 
end;
{$ENDIF FPC_BIG_ENDIAN}
{==============================================================================}

procedure PixelsDefaultToFormat(Format:LongWord;Source,Dest:Pointer;Count:LongWord;Reverse:Boolean); 
{Convert one or more pixels in the default color format to the specified format}
{Format: The color format to convert to (eg COLOR_FORMAT_RGB24)}
{Source: Pointer to the source buffer for the pixels to convert}
{Dest: Pointer to the destination buffer for the converted pixels}
{Count: The number of pixels to be converted}
{Reverse: If true then reverse the byte order of the destination after conversion}
var
 Bytes:LongWord;
 Counter:LongWord;
begin
 {}
 {Check Source}
 if Source = nil then Exit;
 
 {Check Dest}
 if Dest = nil then Exit;
 
 {Check Count}
 if Count = 0 then Exit;
 
 {Check Format}
 if (Format = COLOR_FORMAT_DEFAULT) and not(Reverse) then {COLOR_FORMAT_ARGB32}
  begin
   System.Move(Source^,Dest^,Count * 4);
  end
 else
  begin
   {Get Bytes}
   Bytes:=ColorFormatToBytes(Format);
   if Bytes = 0 then Exit;
   
   {Convert Pixels}
   for Counter:=0 to Count - 1 do
    begin
     {Convert Pixel}
     ColorDefaultToFormat(Format,PLongWord(Source)^,Dest,Reverse);
     
     {Update Source}
     Inc(Source,4);
     
     {Update Dest}
     Inc(Dest,Bytes);
    end;    
  end; 
end;

{==============================================================================}

procedure PixelsFormatToDefault(Format:LongWord;Source,Dest:Pointer;Count:LongWord;Reverse:Boolean);
{Convert one or more pixels in the specified color format to the default format}
{Format: The color format to convert from (eg COLOR_FORMAT_RGB24)}
{Source: Pointer to the source buffer for the pixels to convert}
{Dest: Pointer to the destination buffer for the converted pixels}
{Count: The number of pixels to be converted}
{Reverse: If true then reverse the byte order of the destination after conversion}
var
 Bytes:LongWord;
 Counter:LongWord;
begin
 {}
 {Check Source}
 if Source = nil then Exit;
 
 {Check Dest}
 if Dest = nil then Exit;
 
 {Check Count}
 if Count = 0 then Exit;
 
 {Check Format}
 if (Format = COLOR_FORMAT_DEFAULT) and not(Reverse) then {COLOR_FORMAT_ARGB32}
  begin
   System.Move(Source^,Dest^,Count * 4);
  end
 else
  begin 
   {Get Bytes}
   Bytes:=ColorFormatToBytes(Format);
   if Bytes = 0 then Exit;
   
   {Convert Pixels}
   for Counter:=0 to Count - 1 do
    begin
     {Convert Pixel}
     ColorFormatToDefault(Format,Source,PLongWord(Dest)^,Reverse);
     
     {Update Source}
     Inc(Source,Bytes);
     
     {Update Dest}
     Inc(Dest,4);
    end;    
  end; 
end;

{==============================================================================}

procedure PixelsDefaultAltToFormat(Format:LongWord;Source,Dest:Pointer;Count:LongWord;Reverse:Boolean); 
{Convert one or more pixels in the default color format to the specified format (Alternate)}
{Format: The color format to convert to (eg COLOR_FORMAT_RGB24)}
{Source: Pointer to the source buffer for the pixels to convert}
{Dest: Pointer to the destination buffer for the converted pixels}
{Count: The number of pixels to be converted}
{Reverse: If true then reverse the byte order of the source before conversion (Differs from PixelsDefaultToFormat)}
var
 Bytes:LongWord;
 Counter:LongWord;
begin
 {}
 {Check Source}
 if Source = nil then Exit;
 
 {Check Dest}
 if Dest = nil then Exit;
 
 {Check Count}
 if Count = 0 then Exit;
 
 {Check Format}
 if (Format = COLOR_FORMAT_DEFAULT) and not(Reverse) then {COLOR_FORMAT_ARGB32}
  begin
   System.Move(Source^,Dest^,Count * 4);
  end
 else
  begin
   {Get Bytes}
   Bytes:=ColorFormatToBytes(Format);
   if Bytes = 0 then Exit;
   
   {Convert Pixels}
   for Counter:=0 to Count - 1 do
    begin
     {Convert Pixel} {Note: Does not use ColorDefaultAltToFormat}
     if not(Reverse) then
      begin
       ColorDefaultToFormat(Format,PLongWord(Source)^,Dest,False);
      end
     else
      begin
       ColorDefaultToFormat(Format,SwapEndian(PLongWord(Source)^),Dest,False);
      end;      
     
     {Update Source}
     Inc(Source,4);
     
     {Update Dest}
     Inc(Dest,Bytes);
    end;    
  end; 
end;

{==============================================================================}

procedure PixelsFormatAltToDefault(Format:LongWord;Source,Dest:Pointer;Count:LongWord;Reverse:Boolean);
{Convert one or more pixels in the specified color format to the default format (Alternate)}
{Format: The color format to convert from (eg COLOR_FORMAT_RGB24)}
{Source: Pointer to the source buffer for the pixels to convert}
{Dest: Pointer to the destination buffer for the converted pixels}
{Count: The number of pixels to be converted}
{Reverse: If true then reverse the byte order of the source before conversion (Differs from PixelsFormatToDefault)}
var
 Bytes:LongWord;
 Counter:LongWord;
begin
 {}
 {Check Source}
 if Source = nil then Exit;
 
 {Check Dest}
 if Dest = nil then Exit;
 
 {Check Count}
 if Count = 0 then Exit;
 
 {Check Format}
 if (Format = COLOR_FORMAT_DEFAULT) and not(Reverse) then {COLOR_FORMAT_ARGB32}
  begin
   System.Move(Source^,Dest^,Count * 4);
  end
 else
  begin 
   {Get Bytes}
   Bytes:=ColorFormatToBytes(Format);
   if Bytes = 0 then Exit;
   
   {Convert Pixels}
   for Counter:=0 to Count - 1 do
    begin
     {Convert Pixel}
     ColorFormatAltToDefault(Format,Source,PLongWord(Dest)^,Reverse);
     
     {Update Source}
     Inc(Source,Bytes);
     
     {Update Dest}
     Inc(Dest,4);
    end;    
  end; 
end;

{==============================================================================}

function LogLevelToLoggingSeverity(LogLevel:LongWord):LongWord;
begin
 {}
 Result:=LOGGING_SEVERITY_INFO;
 
 case LogLevel of
  LOG_LEVEL_DEBUG:Result:=LOGGING_SEVERITY_DEBUG;
  LOG_LEVEL_INFO:Result:=LOGGING_SEVERITY_INFO;
  LOG_LEVEL_ERROR:Result:=LOGGING_SEVERITY_ERROR;
 end;
end;

{==============================================================================}
{==============================================================================}

end.
