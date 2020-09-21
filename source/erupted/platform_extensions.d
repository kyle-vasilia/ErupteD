/**
 * Dlang vulkan platform specific types and functions as mixin template
 *
 * Copyright: Copyright 2015-2016 The Khronos Group Inc.; Copyright 2016 Alex Parrill, Peter Particle.
 * License:   $(https://opensource.org/licenses/MIT, MIT License).
 * Authors: Copyright 2016 Alex Parrill, Peter Particle
 */
module erupted.platform_extensions;

/// define platform extension names as enums
/// these enums can be used directly in Platform_Extensions mixin template
enum KHR_xlib_surface;
enum KHR_xcb_surface;
enum KHR_wayland_surface;
enum KHR_android_surface;
enum KHR_win32_surface;
enum KHR_external_memory_win32;
enum KHR_win32_keyed_mutex;
enum KHR_external_semaphore_win32;
enum KHR_external_fence_win32;
enum KHR_deferred_host_operations;
enum KHR_pipeline_library;
enum GGP_stream_descriptor_surface;
enum NV_external_memory_win32;
enum NV_win32_keyed_mutex;
enum NN_vi_surface;
enum EXT_acquire_xlib_display;
enum MVK_ios_surface;
enum MVK_macos_surface;
enum ANDROID_external_memory_android_hardware_buffer;
enum GGP_frame_token;
enum FUCHSIA_imagepipe_surface;
enum EXT_metal_surface;
enum EXT_full_screen_exclusive;
enum EXT_directfb_surface;
enum KHR_ray_tracing;


/// extensions to a specific platform are grouped in these enum sequences
import std.meta : AliasSeq;
alias USE_PLATFORM_XLIB_KHR        = AliasSeq!( KHR_xlib_surface );
alias USE_PLATFORM_XCB_KHR         = AliasSeq!( KHR_xcb_surface );
alias USE_PLATFORM_WAYLAND_KHR     = AliasSeq!( KHR_wayland_surface );
alias USE_PLATFORM_ANDROID_KHR     = AliasSeq!( KHR_android_surface, ANDROID_external_memory_android_hardware_buffer );
alias USE_PLATFORM_WIN32_KHR       = AliasSeq!( KHR_win32_surface, KHR_external_memory_win32, KHR_win32_keyed_mutex, KHR_external_semaphore_win32, KHR_external_fence_win32, NV_external_memory_win32, NV_win32_keyed_mutex, EXT_full_screen_exclusive );
alias ENABLE_BETA_EXTENSIONS       = AliasSeq!( KHR_deferred_host_operations, KHR_pipeline_library, KHR_ray_tracing );
alias USE_PLATFORM_GGP             = AliasSeq!( GGP_stream_descriptor_surface, GGP_frame_token );
alias USE_PLATFORM_VI_NN           = AliasSeq!( NN_vi_surface );
alias USE_PLATFORM_XLIB_XRANDR_EXT = AliasSeq!( EXT_acquire_xlib_display );
alias USE_PLATFORM_IOS_MVK         = AliasSeq!( MVK_ios_surface );
alias USE_PLATFORM_MACOS_MVK       = AliasSeq!( MVK_macos_surface );
alias USE_PLATFORM_FUCHSIA         = AliasSeq!( FUCHSIA_imagepipe_surface );
alias USE_PLATFORM_METAL_EXT       = AliasSeq!( EXT_metal_surface );
alias USE_PLATFORM_DIRECTFB_EXT    = AliasSeq!( EXT_directfb_surface );



/// instantiate platform and extension specific code with this mixin template
/// required types and data structures must be imported into the module where
/// this template is instantiated
mixin template Platform_Extensions( extensions... ) {

    // publicly import erupted package modules
    public import erupted.types;
    public import erupted.functions;
    import erupted.dispatch_device;

    // mixin function linkage, nothrow and @nogc attributes for subsecuent functions
    extern(System) nothrow @nogc:

    // remove duplicates from alias sequence
    // this might happen if a platform extension collection AND a single extension, which is included in the collection, was specified
    // e.g.: mixin Platform_Extensions!( VK_USE_PLATFORM_WIN32_KHR, VK_KHR_external_memory_win32 );
    import std.meta : NoDuplicates;
    alias noDuplicateExtensions = NoDuplicates!extensions;

    // 1. loop through alias sequence and mixin corresponding
    // extension types, aliased function pointer type definitions and __gshared function pointer declarations
    static foreach( extension; noDuplicateExtensions ) {

        // VK_KHR_xlib_surface : types and function pointer type aliases
        static if( __traits( isSame, extension, KHR_xlib_surface )) {
            enum VK_KHR_xlib_surface = 1;

            enum VK_KHR_XLIB_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_XLIB_SURFACE_EXTENSION_NAME = "VK_KHR_xlib_surface";
            
            alias VkXlibSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkXlibSurfaceCreateInfoKHR {
                VkStructureType              sType = VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR;
                const( void )*               pNext;
                VkXlibSurfaceCreateFlagsKHR  flags;
                Display*                     dpy;
                Window                       window;
            }
            
            alias PFN_vkCreateXlibSurfaceKHR                                            = VkResult  function( VkInstance instance, const( VkXlibSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, Display* dpy, VisualID visualID );
        }

        // VK_KHR_xcb_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_xcb_surface )) {
            enum VK_KHR_xcb_surface = 1;

            enum VK_KHR_XCB_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_XCB_SURFACE_EXTENSION_NAME = "VK_KHR_xcb_surface";
            
            alias VkXcbSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkXcbSurfaceCreateInfoKHR {
                VkStructureType             sType = VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR;
                const( void )*              pNext;
                VkXcbSurfaceCreateFlagsKHR  flags;
                xcb_connection_t*           connection;
                xcb_window_t                window;
            }
            
            alias PFN_vkCreateXcbSurfaceKHR                                             = VkResult  function( VkInstance instance, const( VkXcbSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, xcb_connection_t* connection, xcb_visualid_t visual_id );
        }

        // VK_KHR_wayland_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_wayland_surface )) {
            enum VK_KHR_wayland_surface = 1;

            enum VK_KHR_WAYLAND_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME = "VK_KHR_wayland_surface";
            
            alias VkWaylandSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkWaylandSurfaceCreateInfoKHR {
                VkStructureType                 sType = VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR;
                const( void )*                  pNext;
                VkWaylandSurfaceCreateFlagsKHR  flags;
                const( wl_display )*            display;
                const( wl_surface )*            surface;
            }
            
            alias PFN_vkCreateWaylandSurfaceKHR                                         = VkResult  function( VkInstance instance, const( VkWaylandSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, const( wl_display )* display );
        }

        // VK_KHR_android_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_android_surface )) {
            enum VK_KHR_android_surface = 1;

            alias ANativeWindow = ANativeWindow;
            
            enum VK_KHR_ANDROID_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_ANDROID_SURFACE_EXTENSION_NAME = "VK_KHR_android_surface";
            
            alias VkAndroidSurfaceCreateFlagsKHR = VkFlags;
            
            struct VkAndroidSurfaceCreateInfoKHR {
                VkStructureType                 sType = VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR;
                const( void )*                  pNext;
                VkAndroidSurfaceCreateFlagsKHR  flags;
                const( ANativeWindow )*         window;
            }
            
            alias PFN_vkCreateAndroidSurfaceKHR                                         = VkResult  function( VkInstance instance, const( VkAndroidSurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_KHR_win32_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_win32_surface )) {
            enum VK_KHR_win32_surface = 1;

            enum VK_KHR_WIN32_SURFACE_SPEC_VERSION = 6;
            enum VK_KHR_WIN32_SURFACE_EXTENSION_NAME = "VK_KHR_win32_surface";
            
            alias VkWin32SurfaceCreateFlagsKHR = VkFlags;
            
            struct VkWin32SurfaceCreateInfoKHR {
                VkStructureType               sType = VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
                const( void )*                pNext;
                VkWin32SurfaceCreateFlagsKHR  flags;
                HINSTANCE                     hinstance;
                HWND                          hwnd;
            }
            
            alias PFN_vkCreateWin32SurfaceKHR                                           = VkResult  function( VkInstance instance, const( VkWin32SurfaceCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex );
        }

        // VK_KHR_external_memory_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
            enum VK_KHR_external_memory_win32 = 1;

            enum VK_KHR_EXTERNAL_MEMORY_WIN32_SPEC_VERSION = 1;
            enum VK_KHR_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME = "VK_KHR_external_memory_win32";
            
            struct VkImportMemoryWin32HandleInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
                const( void )*                      pNext;
                VkExternalMemoryHandleTypeFlagBits  handleType;
                HANDLE                              handle;
                LPCWSTR                             name;
            }
            
            struct VkExportMemoryWin32HandleInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
                LPCWSTR                        name;
            }
            
            struct VkMemoryWin32HandlePropertiesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_MEMORY_WIN32_HANDLE_PROPERTIES_KHR;
                void*            pNext;
                uint32_t         memoryTypeBits;
            }
            
            struct VkMemoryGetWin32HandleInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
                const( void )*                      pNext;
                VkDeviceMemory                      memory;
                VkExternalMemoryHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkGetMemoryWin32HandleKHR                                         = VkResult  function( VkDevice device, const( VkMemoryGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle );
            alias PFN_vkGetMemoryWin32HandlePropertiesKHR                               = VkResult  function( VkDevice device, VkExternalMemoryHandleTypeFlagBits handleType, HANDLE handle, VkMemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties );
        }

        // VK_KHR_win32_keyed_mutex : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_win32_keyed_mutex )) {
            enum VK_KHR_win32_keyed_mutex = 1;

            enum VK_KHR_WIN32_KEYED_MUTEX_SPEC_VERSION = 1;
            enum VK_KHR_WIN32_KEYED_MUTEX_EXTENSION_NAME = "VK_KHR_win32_keyed_mutex";
            
            struct VkWin32KeyedMutexAcquireReleaseInfoKHR {
                VkStructureType           sType = VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_KHR;
                const( void )*            pNext;
                uint32_t                  acquireCount;
                const( VkDeviceMemory )*  pAcquireSyncs;
                const( uint64_t )*        pAcquireKeys;
                const( uint32_t )*        pAcquireTimeouts;
                uint32_t                  releaseCount;
                const( VkDeviceMemory )*  pReleaseSyncs;
                const( uint64_t )*        pReleaseKeys;
            }
            
        }

        // VK_KHR_external_semaphore_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
            enum VK_KHR_external_semaphore_win32 = 1;

            enum VK_KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION = 1;
            enum VK_KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME = "VK_KHR_external_semaphore_win32";
            
            struct VkImportSemaphoreWin32HandleInfoKHR {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkSemaphoreImportFlags                 flags;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
                HANDLE                                 handle;
                LPCWSTR                                name;
            }
            
            struct VkExportSemaphoreWin32HandleInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
                LPCWSTR                        name;
            }
            
            struct VkD3D12FenceSubmitInfoKHR {
                VkStructureType     sType = VK_STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR;
                const( void )*      pNext;
                uint32_t            waitSemaphoreValuesCount;
                const( uint64_t )*  pWaitSemaphoreValues;
                uint32_t            signalSemaphoreValuesCount;
                const( uint64_t )*  pSignalSemaphoreValues;
            }
            
            struct VkSemaphoreGetWin32HandleInfoKHR {
                VkStructureType                        sType = VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR;
                const( void )*                         pNext;
                VkSemaphore                            semaphore;
                VkExternalSemaphoreHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkImportSemaphoreWin32HandleKHR                                   = VkResult  function( VkDevice device, const( VkImportSemaphoreWin32HandleInfoKHR )* pImportSemaphoreWin32HandleInfo );
            alias PFN_vkGetSemaphoreWin32HandleKHR                                      = VkResult  function( VkDevice device, const( VkSemaphoreGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle );
        }

        // VK_KHR_external_fence_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
            enum VK_KHR_external_fence_win32 = 1;

            enum VK_KHR_EXTERNAL_FENCE_WIN32_SPEC_VERSION = 1;
            enum VK_KHR_EXTERNAL_FENCE_WIN32_EXTENSION_NAME = "VK_KHR_external_fence_win32";
            
            struct VkImportFenceWin32HandleInfoKHR {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_IMPORT_FENCE_WIN32_HANDLE_INFO_KHR;
                const( void )*                     pNext;
                VkFence                            fence;
                VkFenceImportFlags                 flags;
                VkExternalFenceHandleTypeFlagBits  handleType;
                HANDLE                             handle;
                LPCWSTR                            name;
            }
            
            struct VkExportFenceWin32HandleInfoKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_FENCE_WIN32_HANDLE_INFO_KHR;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
                LPCWSTR                        name;
            }
            
            struct VkFenceGetWin32HandleInfoKHR {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_FENCE_GET_WIN32_HANDLE_INFO_KHR;
                const( void )*                     pNext;
                VkFence                            fence;
                VkExternalFenceHandleTypeFlagBits  handleType;
            }
            
            alias PFN_vkImportFenceWin32HandleKHR                                       = VkResult  function( VkDevice device, const( VkImportFenceWin32HandleInfoKHR )* pImportFenceWin32HandleInfo );
            alias PFN_vkGetFenceWin32HandleKHR                                          = VkResult  function( VkDevice device, const( VkFenceGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle );
        }

        // VK_KHR_deferred_host_operations : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_deferred_host_operations )) {
            enum VK_KHR_deferred_host_operations = 1;

            mixin( VK_DEFINE_NON_DISPATCHABLE_HANDLE!q{VkDeferredOperationKHR} );
            
            enum VK_KHR_DEFERRED_HOST_OPERATIONS_SPEC_VERSION = 3;
            enum VK_KHR_DEFERRED_HOST_OPERATIONS_EXTENSION_NAME = "VK_KHR_deferred_host_operations";
            
            struct VkDeferredOperationInfoKHR {
                VkStructureType         sType = VK_STRUCTURE_TYPE_DEFERRED_OPERATION_INFO_KHR;
                const( void )*          pNext;
                VkDeferredOperationKHR  operationHandle;
            }
            
            alias PFN_vkCreateDeferredOperationKHR                                      = VkResult  function( VkDevice device, const( VkAllocationCallbacks )* pAllocator, VkDeferredOperationKHR* pDeferredOperation );
            alias PFN_vkDestroyDeferredOperationKHR                                     = void      function( VkDevice device, VkDeferredOperationKHR operation, const( VkAllocationCallbacks )* pAllocator );
            alias PFN_vkGetDeferredOperationMaxConcurrencyKHR                           = uint32_t  function( VkDevice device, VkDeferredOperationKHR operation );
            alias PFN_vkGetDeferredOperationResultKHR                                   = VkResult  function( VkDevice device, VkDeferredOperationKHR operation );
            alias PFN_vkDeferredOperationJoinKHR                                        = VkResult  function( VkDevice device, VkDeferredOperationKHR operation );
        }

        // VK_KHR_pipeline_library : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_pipeline_library )) {
            enum VK_KHR_pipeline_library = 1;

            enum VK_KHR_PIPELINE_LIBRARY_SPEC_VERSION = 1;
            enum VK_KHR_PIPELINE_LIBRARY_EXTENSION_NAME = "VK_KHR_pipeline_library";
            
            struct VkPipelineLibraryCreateInfoKHR {
                VkStructureType       sType = VK_STRUCTURE_TYPE_PIPELINE_LIBRARY_CREATE_INFO_KHR;
                const( void )*        pNext;
                uint32_t              libraryCount;
                const( VkPipeline )*  pLibraries;
            }
            
        }

        // VK_GGP_stream_descriptor_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
            enum VK_GGP_stream_descriptor_surface = 1;

            enum VK_GGP_STREAM_DESCRIPTOR_SURFACE_SPEC_VERSION = 1;
            enum VK_GGP_STREAM_DESCRIPTOR_SURFACE_EXTENSION_NAME = "VK_GGP_stream_descriptor_surface";
            
            alias VkStreamDescriptorSurfaceCreateFlagsGGP = VkFlags;
            
            struct VkStreamDescriptorSurfaceCreateInfoGGP {
                VkStructureType                          sType = VK_STRUCTURE_TYPE_STREAM_DESCRIPTOR_SURFACE_CREATE_INFO_GGP;
                const( void )*                           pNext;
                VkStreamDescriptorSurfaceCreateFlagsGGP  flags;
                GgpStreamDescriptor                      streamDescriptor;
            }
            
            alias PFN_vkCreateStreamDescriptorSurfaceGGP                                = VkResult  function( VkInstance instance, const( VkStreamDescriptorSurfaceCreateInfoGGP )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_NV_external_memory_win32 : types and function pointer type aliases
        else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
            enum VK_NV_external_memory_win32 = 1;

            enum VK_NV_EXTERNAL_MEMORY_WIN32_SPEC_VERSION = 1;
            enum VK_NV_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME = "VK_NV_external_memory_win32";
            
            struct VkImportMemoryWin32HandleInfoNV {
                VkStructureType                    sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_NV;
                const( void )*                     pNext;
                VkExternalMemoryHandleTypeFlagsNV  handleType;
                HANDLE                             handle;
            }
            
            struct VkExportMemoryWin32HandleInfoNV {
                VkStructureType                sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_NV;
                const( void )*                 pNext;
                const( SECURITY_ATTRIBUTES )*  pAttributes;
                DWORD                          dwAccess;
            }
            
            alias PFN_vkGetMemoryWin32HandleNV                                          = VkResult  function( VkDevice device, VkDeviceMemory memory, VkExternalMemoryHandleTypeFlagsNV handleType, HANDLE* pHandle );
        }

        // VK_NV_win32_keyed_mutex : types and function pointer type aliases
        else static if( __traits( isSame, extension, NV_win32_keyed_mutex )) {
            enum VK_NV_win32_keyed_mutex = 1;

            enum VK_NV_WIN32_KEYED_MUTEX_SPEC_VERSION = 2;
            enum VK_NV_WIN32_KEYED_MUTEX_EXTENSION_NAME = "VK_NV_win32_keyed_mutex";
            
            struct VkWin32KeyedMutexAcquireReleaseInfoNV {
                VkStructureType           sType = VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_NV;
                const( void )*            pNext;
                uint32_t                  acquireCount;
                const( VkDeviceMemory )*  pAcquireSyncs;
                const( uint64_t )*        pAcquireKeys;
                const( uint32_t )*        pAcquireTimeoutMilliseconds;
                uint32_t                  releaseCount;
                const( VkDeviceMemory )*  pReleaseSyncs;
                const( uint64_t )*        pReleaseKeys;
            }
            
        }

        // VK_NN_vi_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, NN_vi_surface )) {
            enum VK_NN_vi_surface = 1;

            enum VK_NN_VI_SURFACE_SPEC_VERSION = 1;
            enum VK_NN_VI_SURFACE_EXTENSION_NAME = "VK_NN_vi_surface";
            
            alias VkViSurfaceCreateFlagsNN = VkFlags;
            
            struct VkViSurfaceCreateInfoNN {
                VkStructureType           sType = VK_STRUCTURE_TYPE_VI_SURFACE_CREATE_INFO_NN;
                const( void )*            pNext;
                VkViSurfaceCreateFlagsNN  flags;
                void*                     window;
            }
            
            alias PFN_vkCreateViSurfaceNN                                               = VkResult  function( VkInstance instance, const( VkViSurfaceCreateInfoNN )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_EXT_acquire_xlib_display : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
            enum VK_EXT_acquire_xlib_display = 1;

            enum VK_EXT_ACQUIRE_XLIB_DISPLAY_SPEC_VERSION = 1;
            enum VK_EXT_ACQUIRE_XLIB_DISPLAY_EXTENSION_NAME = "VK_EXT_acquire_xlib_display";
            
            alias PFN_vkAcquireXlibDisplayEXT                                           = VkResult  function( VkPhysicalDevice physicalDevice, Display* dpy, VkDisplayKHR display );
            alias PFN_vkGetRandROutputDisplayEXT                                        = VkResult  function( VkPhysicalDevice physicalDevice, Display* dpy, RROutput rrOutput, VkDisplayKHR* pDisplay );
        }

        // VK_MVK_ios_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, MVK_ios_surface )) {
            enum VK_MVK_ios_surface = 1;

            enum VK_MVK_IOS_SURFACE_SPEC_VERSION = 3;
            enum VK_MVK_IOS_SURFACE_EXTENSION_NAME = "VK_MVK_ios_surface";
            
            alias VkIOSSurfaceCreateFlagsMVK = VkFlags;
            
            struct VkIOSSurfaceCreateInfoMVK {
                VkStructureType             sType = VK_STRUCTURE_TYPE_IOS_SURFACE_CREATE_INFO_MVK;
                const( void )*              pNext;
                VkIOSSurfaceCreateFlagsMVK  flags;
                const( void )*              pView;
            }
            
            alias PFN_vkCreateIOSSurfaceMVK                                             = VkResult  function( VkInstance instance, const( VkIOSSurfaceCreateInfoMVK )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_MVK_macos_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, MVK_macos_surface )) {
            enum VK_MVK_macos_surface = 1;

            enum VK_MVK_MACOS_SURFACE_SPEC_VERSION = 3;
            enum VK_MVK_MACOS_SURFACE_EXTENSION_NAME = "VK_MVK_macos_surface";
            
            alias VkMacOSSurfaceCreateFlagsMVK = VkFlags;
            
            struct VkMacOSSurfaceCreateInfoMVK {
                VkStructureType               sType = VK_STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK;
                const( void )*                pNext;
                VkMacOSSurfaceCreateFlagsMVK  flags;
                const( void )*                pView;
            }
            
            alias PFN_vkCreateMacOSSurfaceMVK                                           = VkResult  function( VkInstance instance, const( VkMacOSSurfaceCreateInfoMVK )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_ANDROID_external_memory_android_hardware_buffer : types and function pointer type aliases
        else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
            enum VK_ANDROID_external_memory_android_hardware_buffer = 1;

            alias AHardwareBuffer = AHardwareBuffer;
            
            enum VK_ANDROID_EXTERNAL_MEMORY_ANDROID_HARDWARE_BUFFER_SPEC_VERSION = 3;
            enum VK_ANDROID_EXTERNAL_MEMORY_ANDROID_HARDWARE_BUFFER_EXTENSION_NAME = "VK_ANDROID_external_memory_android_hardware_buffer";
            
            struct VkAndroidHardwareBufferUsageANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_USAGE_ANDROID;
                void*            pNext;
                uint64_t         androidHardwareBufferUsage;
            }
            
            struct VkAndroidHardwareBufferPropertiesANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_PROPERTIES_ANDROID;
                void*            pNext;
                VkDeviceSize     allocationSize;
                uint32_t         memoryTypeBits;
            }
            
            struct VkAndroidHardwareBufferFormatPropertiesANDROID {
                VkStructureType                sType = VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_ANDROID;
                void*                          pNext;
                VkFormat                       format;
                uint64_t                       externalFormat;
                VkFormatFeatureFlags           formatFeatures;
                VkComponentMapping             samplerYcbcrConversionComponents;
                VkSamplerYcbcrModelConversion  suggestedYcbcrModel;
                VkSamplerYcbcrRange            suggestedYcbcrRange;
                VkChromaLocation               suggestedXChromaOffset;
                VkChromaLocation               suggestedYChromaOffset;
            }
            
            struct VkImportAndroidHardwareBufferInfoANDROID {
                VkStructureType            sType = VK_STRUCTURE_TYPE_IMPORT_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
                const( void )*             pNext;
                const( AHardwareBuffer )*  buffer;
            }
            
            struct VkMemoryGetAndroidHardwareBufferInfoANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_MEMORY_GET_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
                const( void )*   pNext;
                VkDeviceMemory   memory;
            }
            
            struct VkExternalFormatANDROID {
                VkStructureType  sType = VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_ANDROID;
                void*            pNext;
                uint64_t         externalFormat;
            }
            
            alias PFN_vkGetAndroidHardwareBufferPropertiesANDROID                       = VkResult  function( VkDevice device, const( AHardwareBuffer )* buffer, VkAndroidHardwareBufferPropertiesANDROID* pProperties );
            alias PFN_vkGetMemoryAndroidHardwareBufferANDROID                           = VkResult  function( VkDevice device, const( VkMemoryGetAndroidHardwareBufferInfoANDROID )* pInfo, AHardwareBuffer pBuffer );
        }

        // VK_GGP_frame_token : types and function pointer type aliases
        else static if( __traits( isSame, extension, GGP_frame_token )) {
            enum VK_GGP_frame_token = 1;

            enum VK_GGP_FRAME_TOKEN_SPEC_VERSION = 1;
            enum VK_GGP_FRAME_TOKEN_EXTENSION_NAME = "VK_GGP_frame_token";
            
            struct VkPresentFrameTokenGGP {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PRESENT_FRAME_TOKEN_GGP;
                const( void )*   pNext;
                GgpFrameToken    frameToken;
            }
            
        }

        // VK_FUCHSIA_imagepipe_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
            enum VK_FUCHSIA_imagepipe_surface = 1;

            enum VK_FUCHSIA_IMAGEPIPE_SURFACE_SPEC_VERSION = 1;
            enum VK_FUCHSIA_IMAGEPIPE_SURFACE_EXTENSION_NAME = "VK_FUCHSIA_imagepipe_surface";
            
            alias VkImagePipeSurfaceCreateFlagsFUCHSIA = VkFlags;
            
            struct VkImagePipeSurfaceCreateInfoFUCHSIA {
                VkStructureType                       sType = VK_STRUCTURE_TYPE_IMAGEPIPE_SURFACE_CREATE_INFO_FUCHSIA;
                const( void )*                        pNext;
                VkImagePipeSurfaceCreateFlagsFUCHSIA  flags;
                zx_handle_t                           imagePipeHandle;
            }
            
            alias PFN_vkCreateImagePipeSurfaceFUCHSIA                                   = VkResult  function( VkInstance instance, const( VkImagePipeSurfaceCreateInfoFUCHSIA )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_EXT_metal_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_metal_surface )) {
            enum VK_EXT_metal_surface = 1;

            alias CAMetalLayer = CAMetalLayer;
            
            enum VK_EXT_METAL_SURFACE_SPEC_VERSION = 1;
            enum VK_EXT_METAL_SURFACE_EXTENSION_NAME = "VK_EXT_metal_surface";
            
            alias VkMetalSurfaceCreateFlagsEXT = VkFlags;
            
            struct VkMetalSurfaceCreateInfoEXT {
                VkStructureType               sType = VK_STRUCTURE_TYPE_METAL_SURFACE_CREATE_INFO_EXT;
                const( void )*                pNext;
                VkMetalSurfaceCreateFlagsEXT  flags;
                const( CAMetalLayer )*        pLayer;
            }
            
            alias PFN_vkCreateMetalSurfaceEXT                                           = VkResult  function( VkInstance instance, const( VkMetalSurfaceCreateInfoEXT )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
        }

        // VK_EXT_full_screen_exclusive : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
            enum VK_EXT_full_screen_exclusive = 1;

            enum VK_EXT_FULL_SCREEN_EXCLUSIVE_SPEC_VERSION = 4;
            enum VK_EXT_FULL_SCREEN_EXCLUSIVE_EXTENSION_NAME = "VK_EXT_full_screen_exclusive";
            
            enum VkFullScreenExclusiveEXT {
                VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT                 = 0,
                VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT                 = 1,
                VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT              = 2,
                VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT  = 3,
                VK_FULL_SCREEN_EXCLUSIVE_BEGIN_RANGE_EXT             = VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT,
                VK_FULL_SCREEN_EXCLUSIVE_END_RANGE_EXT               = VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT,
                VK_FULL_SCREEN_EXCLUSIVE_RANGE_SIZE_EXT              = VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT - VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT + 1,
                VK_FULL_SCREEN_EXCLUSIVE_MAX_ENUM_EXT                = 0x7FFFFFFF
            }
            
            enum VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT                = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_DEFAULT_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT                = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_ALLOWED_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT             = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_DISALLOWED_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_BEGIN_RANGE_EXT            = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_BEGIN_RANGE_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_END_RANGE_EXT              = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_END_RANGE_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_RANGE_SIZE_EXT             = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_RANGE_SIZE_EXT;
            enum VK_FULL_SCREEN_EXCLUSIVE_MAX_ENUM_EXT               = VkFullScreenExclusiveEXT.VK_FULL_SCREEN_EXCLUSIVE_MAX_ENUM_EXT;
            
            struct VkSurfaceFullScreenExclusiveInfoEXT {
                VkStructureType           sType = VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_INFO_EXT;
                void*                     pNext;
                VkFullScreenExclusiveEXT  fullScreenExclusive;
            }
            
            struct VkSurfaceCapabilitiesFullScreenExclusiveEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_FULL_SCREEN_EXCLUSIVE_EXT;
                void*            pNext;
                VkBool32         fullScreenExclusiveSupported;
            }
            
            struct VkSurfaceFullScreenExclusiveWin32InfoEXT {
                VkStructureType  sType = VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_WIN32_INFO_EXT;
                const( void )*   pNext;
                HMONITOR         hmonitor;
            }
            
            alias PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        = VkResult  function( VkPhysicalDevice physicalDevice, const( VkPhysicalDeviceSurfaceInfo2KHR )* pSurfaceInfo, uint32_t* pPresentModeCount, VkPresentModeKHR* pPresentModes );
            alias PFN_vkAcquireFullScreenExclusiveModeEXT                               = VkResult  function( VkDevice device, VkSwapchainKHR swapchain );
            alias PFN_vkReleaseFullScreenExclusiveModeEXT                               = VkResult  function( VkDevice device, VkSwapchainKHR swapchain );
            alias PFN_vkGetDeviceGroupSurfacePresentModes2EXT                           = VkResult  function( VkDevice device, const( VkPhysicalDeviceSurfaceInfo2KHR )* pSurfaceInfo, VkDeviceGroupPresentModeFlagsKHR* pModes );
        }

        // VK_EXT_directfb_surface : types and function pointer type aliases
        else static if( __traits( isSame, extension, EXT_directfb_surface )) {
            enum VK_EXT_directfb_surface = 1;

            enum VK_EXT_DIRECTFB_SURFACE_SPEC_VERSION = 1;
            enum VK_EXT_DIRECTFB_SURFACE_EXTENSION_NAME = "VK_EXT_directfb_surface";
            
            alias VkDirectFBSurfaceCreateFlagsEXT = VkFlags;
            
            struct VkDirectFBSurfaceCreateInfoEXT {
                VkStructureType                  sType = VK_STRUCTURE_TYPE_DIRECTFB_SURFACE_CREATE_INFO_EXT;
                const( void )*                   pNext;
                VkDirectFBSurfaceCreateFlagsEXT  flags;
                IDirectFB*                       dfb;
                IDirectFBSurface*                surface;
            }
            
            alias PFN_vkCreateDirectFBSurfaceEXT                                        = VkResult  function( VkInstance instance, const( VkDirectFBSurfaceCreateInfoEXT )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkSurfaceKHR* pSurface );
            alias PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 = VkBool32  function( VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, IDirectFB* dfb );
        }

        // VK_KHR_ray_tracing : types and function pointer type aliases
        else static if( __traits( isSame, extension, KHR_ray_tracing )) {
            enum VK_KHR_ray_tracing = 1;

            enum VK_KHR_RAY_TRACING_SPEC_VERSION = 8;
            enum VK_KHR_RAY_TRACING_EXTENSION_NAME = "VK_KHR_ray_tracing";
            
            enum VkAccelerationStructureBuildTypeKHR {
                VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_KHR                = 0,
                VK_ACCELERATION_STRUCTURE_BUILD_TYPE_DEVICE_KHR              = 1,
                VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_OR_DEVICE_KHR      = 2,
                VK_ACCELERATION_STRUCTURE_BUILD_TYPE_BEGIN_RANGE_KHR         = VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_KHR,
                VK_ACCELERATION_STRUCTURE_BUILD_TYPE_END_RANGE_KHR           = VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_OR_DEVICE_KHR,
                VK_ACCELERATION_STRUCTURE_BUILD_TYPE_RANGE_SIZE_KHR          = VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_OR_DEVICE_KHR - VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_KHR + 1,
                VK_ACCELERATION_STRUCTURE_BUILD_TYPE_MAX_ENUM_KHR            = 0x7FFFFFFF
            }
            
            enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_KHR               = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_KHR;
            enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_DEVICE_KHR             = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_DEVICE_KHR;
            enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_OR_DEVICE_KHR     = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_OR_DEVICE_KHR;
            enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_BEGIN_RANGE_KHR        = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_BEGIN_RANGE_KHR;
            enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_END_RANGE_KHR          = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_END_RANGE_KHR;
            enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_RANGE_SIZE_KHR         = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_RANGE_SIZE_KHR;
            enum VK_ACCELERATION_STRUCTURE_BUILD_TYPE_MAX_ENUM_KHR           = VkAccelerationStructureBuildTypeKHR.VK_ACCELERATION_STRUCTURE_BUILD_TYPE_MAX_ENUM_KHR;
            
            union VkDeviceOrHostAddressKHR {
                VkDeviceAddress  deviceAddress;
                void*            hostAddress;
            }
            
            union VkDeviceOrHostAddressConstKHR {
                VkDeviceAddress  deviceAddress;
                const( void )*   hostAddress;
            }
            
            struct VkAccelerationStructureBuildOffsetInfoKHR {
                uint32_t  primitiveCount;
                uint32_t  primitiveOffset;
                uint32_t  firstVertex;
                uint32_t  transformOffset;
            }
            
            struct VkRayTracingShaderGroupCreateInfoKHR {
                VkStructureType                 sType = VK_STRUCTURE_TYPE_RAY_TRACING_SHADER_GROUP_CREATE_INFO_KHR;
                const( void )*                  pNext;
                VkRayTracingShaderGroupTypeKHR  type;
                uint32_t                        generalShader;
                uint32_t                        closestHitShader;
                uint32_t                        anyHitShader;
                uint32_t                        intersectionShader;
                const( void )*                  pShaderGroupCaptureReplayHandle;
            }
            
            struct VkRayTracingPipelineInterfaceCreateInfoKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_INTERFACE_CREATE_INFO_KHR;
                const( void )*   pNext;
                uint32_t         maxPayloadSize;
                uint32_t         maxAttributeSize;
                uint32_t         maxCallableSize;
            }
            
            struct VkRayTracingPipelineCreateInfoKHR {
                VkStructureType                                       sType = VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CREATE_INFO_KHR;
                const( void )*                                        pNext;
                VkPipelineCreateFlags                                 flags;
                uint32_t                                              stageCount;
                const( VkPipelineShaderStageCreateInfo )*             pStages;
                uint32_t                                              groupCount;
                const( VkRayTracingShaderGroupCreateInfoKHR )*        pGroups;
                uint32_t                                              maxRecursionDepth;
                VkPipelineLibraryCreateInfoKHR                        libraries;
                const( VkRayTracingPipelineInterfaceCreateInfoKHR )*  pLibraryInterface;
                VkPipelineLayout                                      layout;
                VkPipeline                                            basePipelineHandle;
                int32_t                                               basePipelineIndex;
            }
            
            struct VkAccelerationStructureGeometryTrianglesDataKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_TRIANGLES_DATA_KHR;
                const( void )*                 pNext;
                VkFormat                       vertexFormat;
                VkDeviceOrHostAddressConstKHR  vertexData;
                VkDeviceSize                   vertexStride;
                VkIndexType                    indexType;
                VkDeviceOrHostAddressConstKHR  indexData;
                VkDeviceOrHostAddressConstKHR  transformData;
            }
            
            struct VkAccelerationStructureGeometryAabbsDataKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_AABBS_DATA_KHR;
                const( void )*                 pNext;
                VkDeviceOrHostAddressConstKHR  data;
                VkDeviceSize                   stride;
            }
            
            struct VkAccelerationStructureGeometryInstancesDataKHR {
                VkStructureType                sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_INSTANCES_DATA_KHR;
                const( void )*                 pNext;
                VkBool32                       arrayOfPointers;
                VkDeviceOrHostAddressConstKHR  data;
            }
            
            union VkAccelerationStructureGeometryDataKHR {
                VkAccelerationStructureGeometryTrianglesDataKHR  triangles;
                VkAccelerationStructureGeometryAabbsDataKHR      aabbs;
                VkAccelerationStructureGeometryInstancesDataKHR  instances;
            }
            
            struct VkAccelerationStructureGeometryKHR {
                VkStructureType                         sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_KHR;
                const( void )*                          pNext;
                VkGeometryTypeKHR                       geometryType;
                VkAccelerationStructureGeometryDataKHR  geometry;
                VkGeometryFlagsKHR                      flags;
            }
            
            struct VkAccelerationStructureBuildGeometryInfoKHR {
                VkStructureType                                sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_BUILD_GEOMETRY_INFO_KHR;
                const( void )*                                 pNext;
                VkAccelerationStructureTypeKHR                 type;
                VkBuildAccelerationStructureFlagsKHR           flags;
                VkBool32                                       update;
                VkAccelerationStructureKHR                     srcAccelerationStructure;
                VkAccelerationStructureKHR                     dstAccelerationStructure;
                VkBool32                                       geometryArrayOfPointers;
                uint32_t                                       geometryCount;
                const( VkAccelerationStructureGeometryKHR* )*  ppGeometries;
                VkDeviceOrHostAddressKHR                       scratchData;
            }
            
            struct VkAccelerationStructureCreateGeometryTypeInfoKHR {
                VkStructureType    sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CREATE_GEOMETRY_TYPE_INFO_KHR;
                const( void )*     pNext;
                VkGeometryTypeKHR  geometryType;
                uint32_t           maxPrimitiveCount;
                VkIndexType        indexType;
                uint32_t           maxVertexCount;
                VkFormat           vertexFormat;
                VkBool32           allowsTransforms;
            }
            
            struct VkAccelerationStructureCreateInfoKHR {
                VkStructureType                                             sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CREATE_INFO_KHR;
                const( void )*                                              pNext;
                VkDeviceSize                                                compactedSize;
                VkAccelerationStructureTypeKHR                              type;
                VkBuildAccelerationStructureFlagsKHR                        flags;
                uint32_t                                                    maxGeometryCount;
                const( VkAccelerationStructureCreateGeometryTypeInfoKHR )*  pGeometryInfos;
                VkDeviceAddress                                             deviceAddress;
            }
            
            struct VkAccelerationStructureMemoryRequirementsInfoKHR {
                VkStructureType                                   sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_INFO_KHR;
                const( void )*                                    pNext;
                VkAccelerationStructureMemoryRequirementsTypeKHR  type;
                VkAccelerationStructureBuildTypeKHR               buildType;
                VkAccelerationStructureKHR                        accelerationStructure;
            }
            
            struct VkPhysicalDeviceRayTracingFeaturesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_FEATURES_KHR;
                void*            pNext;
                VkBool32         rayTracing;
                VkBool32         rayTracingShaderGroupHandleCaptureReplay;
                VkBool32         rayTracingShaderGroupHandleCaptureReplayMixed;
                VkBool32         rayTracingAccelerationStructureCaptureReplay;
                VkBool32         rayTracingIndirectTraceRays;
                VkBool32         rayTracingIndirectAccelerationStructureBuild;
                VkBool32         rayTracingHostAccelerationStructureCommands;
                VkBool32         rayQuery;
                VkBool32         rayTracingPrimitiveCulling;
            }
            
            struct VkPhysicalDeviceRayTracingPropertiesKHR {
                VkStructureType  sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PROPERTIES_KHR;
                void*            pNext;
                uint32_t         shaderGroupHandleSize;
                uint32_t         maxRecursionDepth;
                uint32_t         maxShaderGroupStride;
                uint32_t         shaderGroupBaseAlignment;
                uint64_t         maxGeometryCount;
                uint64_t         maxInstanceCount;
                uint64_t         maxPrimitiveCount;
                uint32_t         maxDescriptorSetAccelerationStructures;
                uint32_t         shaderGroupHandleCaptureReplaySize;
            }
            
            struct VkAccelerationStructureDeviceAddressInfoKHR {
                VkStructureType             sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_DEVICE_ADDRESS_INFO_KHR;
                const( void )*              pNext;
                VkAccelerationStructureKHR  accelerationStructure;
            }
            
            struct VkAccelerationStructureVersionKHR {
                VkStructureType    sType = VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_VERSION_KHR;
                const( void )*     pNext;
                const( uint8_t )*  versionData;
            }
            
            struct VkStridedBufferRegionKHR {
                VkBuffer      buffer;
                VkDeviceSize  offset;
                VkDeviceSize  stride;
                VkDeviceSize  size;
            }
            
            struct VkTraceRaysIndirectCommandKHR {
                uint32_t  width;
                uint32_t  height;
                uint32_t  depth;
            }
            
            struct VkCopyAccelerationStructureToMemoryInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_COPY_ACCELERATION_STRUCTURE_TO_MEMORY_INFO_KHR;
                const( void )*                      pNext;
                VkAccelerationStructureKHR          src;
                VkDeviceOrHostAddressKHR            dst;
                VkCopyAccelerationStructureModeKHR  mode;
            }
            
            struct VkCopyMemoryToAccelerationStructureInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_COPY_MEMORY_TO_ACCELERATION_STRUCTURE_INFO_KHR;
                const( void )*                      pNext;
                VkDeviceOrHostAddressConstKHR       src;
                VkAccelerationStructureKHR          dst;
                VkCopyAccelerationStructureModeKHR  mode;
            }
            
            struct VkCopyAccelerationStructureInfoKHR {
                VkStructureType                     sType = VK_STRUCTURE_TYPE_COPY_ACCELERATION_STRUCTURE_INFO_KHR;
                const( void )*                      pNext;
                VkAccelerationStructureKHR          src;
                VkAccelerationStructureKHR          dst;
                VkCopyAccelerationStructureModeKHR  mode;
            }
            
            alias PFN_vkCreateAccelerationStructureKHR                                  = VkResult  function( VkDevice device, const( VkAccelerationStructureCreateInfoKHR )* pCreateInfo, const( VkAllocationCallbacks )* pAllocator, VkAccelerationStructureKHR* pAccelerationStructure );
            alias PFN_vkGetAccelerationStructureMemoryRequirementsKHR                   = void      function( VkDevice device, const( VkAccelerationStructureMemoryRequirementsInfoKHR )* pInfo, VkMemoryRequirements2* pMemoryRequirements );
            alias PFN_vkCmdBuildAccelerationStructureKHR                                = void      function( VkCommandBuffer commandBuffer, uint32_t infoCount, const( VkAccelerationStructureBuildGeometryInfoKHR )* pInfos, const( VkAccelerationStructureBuildOffsetInfoKHR* )* ppOffsetInfos );
            alias PFN_vkCmdBuildAccelerationStructureIndirectKHR                        = void      function( VkCommandBuffer commandBuffer, const( VkAccelerationStructureBuildGeometryInfoKHR )* pInfo, VkBuffer indirectBuffer, VkDeviceSize indirectOffset, uint32_t indirectStride );
            alias PFN_vkBuildAccelerationStructureKHR                                   = VkResult  function( VkDevice device, uint32_t infoCount, const( VkAccelerationStructureBuildGeometryInfoKHR )* pInfos, const( VkAccelerationStructureBuildOffsetInfoKHR* )* ppOffsetInfos );
            alias PFN_vkCopyAccelerationStructureKHR                                    = VkResult  function( VkDevice device, const( VkCopyAccelerationStructureInfoKHR )* pInfo );
            alias PFN_vkCopyAccelerationStructureToMemoryKHR                            = VkResult  function( VkDevice device, const( VkCopyAccelerationStructureToMemoryInfoKHR )* pInfo );
            alias PFN_vkCopyMemoryToAccelerationStructureKHR                            = VkResult  function( VkDevice device, const( VkCopyMemoryToAccelerationStructureInfoKHR )* pInfo );
            alias PFN_vkWriteAccelerationStructuresPropertiesKHR                        = VkResult  function( VkDevice device, uint32_t accelerationStructureCount, const( VkAccelerationStructureKHR )* pAccelerationStructures, VkQueryType queryType, size_t dataSize, void* pData, size_t stride );
            alias PFN_vkCmdCopyAccelerationStructureKHR                                 = void      function( VkCommandBuffer commandBuffer, const( VkCopyAccelerationStructureInfoKHR )* pInfo );
            alias PFN_vkCmdCopyAccelerationStructureToMemoryKHR                         = void      function( VkCommandBuffer commandBuffer, const( VkCopyAccelerationStructureToMemoryInfoKHR )* pInfo );
            alias PFN_vkCmdCopyMemoryToAccelerationStructureKHR                         = void      function( VkCommandBuffer commandBuffer, const( VkCopyMemoryToAccelerationStructureInfoKHR )* pInfo );
            alias PFN_vkCmdTraceRaysKHR                                                 = void      function( VkCommandBuffer commandBuffer, const( VkStridedBufferRegionKHR )* pRaygenShaderBindingTable, const( VkStridedBufferRegionKHR )* pMissShaderBindingTable, const( VkStridedBufferRegionKHR )* pHitShaderBindingTable, const( VkStridedBufferRegionKHR )* pCallableShaderBindingTable, uint32_t width, uint32_t height, uint32_t depth );
            alias PFN_vkCreateRayTracingPipelinesKHR                                    = VkResult  function( VkDevice device, VkPipelineCache pipelineCache, uint32_t createInfoCount, const( VkRayTracingPipelineCreateInfoKHR )* pCreateInfos, const( VkAllocationCallbacks )* pAllocator, VkPipeline* pPipelines );
            alias PFN_vkGetAccelerationStructureDeviceAddressKHR                        = VkDeviceAddress  function( VkDevice device, const( VkAccelerationStructureDeviceAddressInfoKHR )* pInfo );
            alias PFN_vkGetRayTracingCaptureReplayShaderGroupHandlesKHR                 = VkResult  function( VkDevice device, VkPipeline pipeline, uint32_t firstGroup, uint32_t groupCount, size_t dataSize, void* pData );
            alias PFN_vkCmdTraceRaysIndirectKHR                                         = void      function( VkCommandBuffer commandBuffer, const( VkStridedBufferRegionKHR )* pRaygenShaderBindingTable, const( VkStridedBufferRegionKHR )* pMissShaderBindingTable, const( VkStridedBufferRegionKHR )* pHitShaderBindingTable, const( VkStridedBufferRegionKHR )* pCallableShaderBindingTable, VkBuffer buffer, VkDeviceSize offset );
            alias PFN_vkGetDeviceAccelerationStructureCompatibilityKHR                  = VkResult  function( VkDevice device, const( VkAccelerationStructureVersionKHR )* Version );
        }

        __gshared {

            // VK_KHR_xlib_surface : function pointer decelerations
            static if( __traits( isSame, extension, KHR_xlib_surface )) {
                PFN_vkCreateXlibSurfaceKHR                                            vkCreateXlibSurfaceKHR;
                PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     vkGetPhysicalDeviceXlibPresentationSupportKHR;
            }

            // VK_KHR_xcb_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_xcb_surface )) {
                PFN_vkCreateXcbSurfaceKHR                                             vkCreateXcbSurfaceKHR;
                PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      vkGetPhysicalDeviceXcbPresentationSupportKHR;
            }

            // VK_KHR_wayland_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_wayland_surface )) {
                PFN_vkCreateWaylandSurfaceKHR                                         vkCreateWaylandSurfaceKHR;
                PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  vkGetPhysicalDeviceWaylandPresentationSupportKHR;
            }

            // VK_KHR_android_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_android_surface )) {
                PFN_vkCreateAndroidSurfaceKHR                                         vkCreateAndroidSurfaceKHR;
            }

            // VK_KHR_win32_surface : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_win32_surface )) {
                PFN_vkCreateWin32SurfaceKHR                                           vkCreateWin32SurfaceKHR;
                PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    vkGetPhysicalDeviceWin32PresentationSupportKHR;
            }

            // VK_KHR_external_memory_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleKHR                                         vkGetMemoryWin32HandleKHR;
                PFN_vkGetMemoryWin32HandlePropertiesKHR                               vkGetMemoryWin32HandlePropertiesKHR;
            }

            // VK_KHR_external_semaphore_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                PFN_vkImportSemaphoreWin32HandleKHR                                   vkImportSemaphoreWin32HandleKHR;
                PFN_vkGetSemaphoreWin32HandleKHR                                      vkGetSemaphoreWin32HandleKHR;
            }

            // VK_KHR_external_fence_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                PFN_vkImportFenceWin32HandleKHR                                       vkImportFenceWin32HandleKHR;
                PFN_vkGetFenceWin32HandleKHR                                          vkGetFenceWin32HandleKHR;
            }

            // VK_KHR_deferred_host_operations : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_deferred_host_operations )) {
                PFN_vkCreateDeferredOperationKHR                                      vkCreateDeferredOperationKHR;
                PFN_vkDestroyDeferredOperationKHR                                     vkDestroyDeferredOperationKHR;
                PFN_vkGetDeferredOperationMaxConcurrencyKHR                           vkGetDeferredOperationMaxConcurrencyKHR;
                PFN_vkGetDeferredOperationResultKHR                                   vkGetDeferredOperationResultKHR;
                PFN_vkDeferredOperationJoinKHR                                        vkDeferredOperationJoinKHR;
            }

            // VK_GGP_stream_descriptor_surface : function pointer decelerations
            else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
                PFN_vkCreateStreamDescriptorSurfaceGGP                                vkCreateStreamDescriptorSurfaceGGP;
            }

            // VK_NV_external_memory_win32 : function pointer decelerations
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleNV                                          vkGetMemoryWin32HandleNV;
            }

            // VK_NN_vi_surface : function pointer decelerations
            else static if( __traits( isSame, extension, NN_vi_surface )) {
                PFN_vkCreateViSurfaceNN                                               vkCreateViSurfaceNN;
            }

            // VK_EXT_acquire_xlib_display : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
                PFN_vkAcquireXlibDisplayEXT                                           vkAcquireXlibDisplayEXT;
                PFN_vkGetRandROutputDisplayEXT                                        vkGetRandROutputDisplayEXT;
            }

            // VK_MVK_ios_surface : function pointer decelerations
            else static if( __traits( isSame, extension, MVK_ios_surface )) {
                PFN_vkCreateIOSSurfaceMVK                                             vkCreateIOSSurfaceMVK;
            }

            // VK_MVK_macos_surface : function pointer decelerations
            else static if( __traits( isSame, extension, MVK_macos_surface )) {
                PFN_vkCreateMacOSSurfaceMVK                                           vkCreateMacOSSurfaceMVK;
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : function pointer decelerations
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                PFN_vkGetAndroidHardwareBufferPropertiesANDROID                       vkGetAndroidHardwareBufferPropertiesANDROID;
                PFN_vkGetMemoryAndroidHardwareBufferANDROID                           vkGetMemoryAndroidHardwareBufferANDROID;
            }

            // VK_FUCHSIA_imagepipe_surface : function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
                PFN_vkCreateImagePipeSurfaceFUCHSIA                                   vkCreateImagePipeSurfaceFUCHSIA;
            }

            // VK_EXT_metal_surface : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_metal_surface )) {
                PFN_vkCreateMetalSurfaceEXT                                           vkCreateMetalSurfaceEXT;
            }

            // VK_EXT_full_screen_exclusive : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        vkGetPhysicalDeviceSurfacePresentModes2EXT;
                PFN_vkAcquireFullScreenExclusiveModeEXT                               vkAcquireFullScreenExclusiveModeEXT;
                PFN_vkReleaseFullScreenExclusiveModeEXT                               vkReleaseFullScreenExclusiveModeEXT;
                PFN_vkGetDeviceGroupSurfacePresentModes2EXT                           vkGetDeviceGroupSurfacePresentModes2EXT;
            }

            // VK_EXT_directfb_surface : function pointer decelerations
            else static if( __traits( isSame, extension, EXT_directfb_surface )) {
                PFN_vkCreateDirectFBSurfaceEXT                                        vkCreateDirectFBSurfaceEXT;
                PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 vkGetPhysicalDeviceDirectFBPresentationSupportEXT;
            }

            // VK_KHR_ray_tracing : function pointer decelerations
            else static if( __traits( isSame, extension, KHR_ray_tracing )) {
                PFN_vkCreateAccelerationStructureKHR                                  vkCreateAccelerationStructureKHR;
                PFN_vkGetAccelerationStructureMemoryRequirementsKHR                   vkGetAccelerationStructureMemoryRequirementsKHR;
                PFN_vkCmdBuildAccelerationStructureKHR                                vkCmdBuildAccelerationStructureKHR;
                PFN_vkCmdBuildAccelerationStructureIndirectKHR                        vkCmdBuildAccelerationStructureIndirectKHR;
                PFN_vkBuildAccelerationStructureKHR                                   vkBuildAccelerationStructureKHR;
                PFN_vkCopyAccelerationStructureKHR                                    vkCopyAccelerationStructureKHR;
                PFN_vkCopyAccelerationStructureToMemoryKHR                            vkCopyAccelerationStructureToMemoryKHR;
                PFN_vkCopyMemoryToAccelerationStructureKHR                            vkCopyMemoryToAccelerationStructureKHR;
                PFN_vkWriteAccelerationStructuresPropertiesKHR                        vkWriteAccelerationStructuresPropertiesKHR;
                PFN_vkCmdCopyAccelerationStructureKHR                                 vkCmdCopyAccelerationStructureKHR;
                PFN_vkCmdCopyAccelerationStructureToMemoryKHR                         vkCmdCopyAccelerationStructureToMemoryKHR;
                PFN_vkCmdCopyMemoryToAccelerationStructureKHR                         vkCmdCopyMemoryToAccelerationStructureKHR;
                PFN_vkCmdTraceRaysKHR                                                 vkCmdTraceRaysKHR;
                PFN_vkCreateRayTracingPipelinesKHR                                    vkCreateRayTracingPipelinesKHR;
                PFN_vkGetAccelerationStructureDeviceAddressKHR                        vkGetAccelerationStructureDeviceAddressKHR;
                PFN_vkGetRayTracingCaptureReplayShaderGroupHandlesKHR                 vkGetRayTracingCaptureReplayShaderGroupHandlesKHR;
                PFN_vkCmdTraceRaysIndirectKHR                                         vkCmdTraceRaysIndirectKHR;
                PFN_vkGetDeviceAccelerationStructureCompatibilityKHR                  vkGetDeviceAccelerationStructureCompatibilityKHR;
            }
        }
    }

    // compose a new loadInstanceLevelFunctions function out of
    // unextended original function and additional function pointers from extensions
    void loadInstanceLevelFunctionsKHR( VkInstance instance ) {

        // first load all non platform related function pointers from implementation
        erupted.functions.loadInstanceLevelFunctions( instance );

        // 2. loop through alias sequence and mixin corresponding
        // instance level function pointer definitions
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_xlib_surface : load instance level function definitions
            static if( __traits( isSame, extension, KHR_xlib_surface )) {
                vkCreateXlibSurfaceKHR                                            = cast( PFN_vkCreateXlibSurfaceKHR                                            ) vkGetInstanceProcAddr( instance, "vkCreateXlibSurfaceKHR" );
                vkGetPhysicalDeviceXlibPresentationSupportKHR                     = cast( PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceXlibPresentationSupportKHR" );
            }

            // VK_KHR_xcb_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_xcb_surface )) {
                vkCreateXcbSurfaceKHR                                             = cast( PFN_vkCreateXcbSurfaceKHR                                             ) vkGetInstanceProcAddr( instance, "vkCreateXcbSurfaceKHR" );
                vkGetPhysicalDeviceXcbPresentationSupportKHR                      = cast( PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceXcbPresentationSupportKHR" );
            }

            // VK_KHR_wayland_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_wayland_surface )) {
                vkCreateWaylandSurfaceKHR                                         = cast( PFN_vkCreateWaylandSurfaceKHR                                         ) vkGetInstanceProcAddr( instance, "vkCreateWaylandSurfaceKHR" );
                vkGetPhysicalDeviceWaylandPresentationSupportKHR                  = cast( PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceWaylandPresentationSupportKHR" );
            }

            // VK_KHR_android_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_android_surface )) {
                vkCreateAndroidSurfaceKHR                                         = cast( PFN_vkCreateAndroidSurfaceKHR                                         ) vkGetInstanceProcAddr( instance, "vkCreateAndroidSurfaceKHR" );
            }

            // VK_KHR_win32_surface : load instance level function definitions
            else static if( __traits( isSame, extension, KHR_win32_surface )) {
                vkCreateWin32SurfaceKHR                                           = cast( PFN_vkCreateWin32SurfaceKHR                                           ) vkGetInstanceProcAddr( instance, "vkCreateWin32SurfaceKHR" );
                vkGetPhysicalDeviceWin32PresentationSupportKHR                    = cast( PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceWin32PresentationSupportKHR" );
            }

            // VK_GGP_stream_descriptor_surface : load instance level function definitions
            else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
                vkCreateStreamDescriptorSurfaceGGP                                = cast( PFN_vkCreateStreamDescriptorSurfaceGGP                                ) vkGetInstanceProcAddr( instance, "vkCreateStreamDescriptorSurfaceGGP" );
            }

            // VK_NN_vi_surface : load instance level function definitions
            else static if( __traits( isSame, extension, NN_vi_surface )) {
                vkCreateViSurfaceNN                                               = cast( PFN_vkCreateViSurfaceNN                                               ) vkGetInstanceProcAddr( instance, "vkCreateViSurfaceNN" );
            }

            // VK_EXT_acquire_xlib_display : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
                vkAcquireXlibDisplayEXT                                           = cast( PFN_vkAcquireXlibDisplayEXT                                           ) vkGetInstanceProcAddr( instance, "vkAcquireXlibDisplayEXT" );
                vkGetRandROutputDisplayEXT                                        = cast( PFN_vkGetRandROutputDisplayEXT                                        ) vkGetInstanceProcAddr( instance, "vkGetRandROutputDisplayEXT" );
            }

            // VK_MVK_ios_surface : load instance level function definitions
            else static if( __traits( isSame, extension, MVK_ios_surface )) {
                vkCreateIOSSurfaceMVK                                             = cast( PFN_vkCreateIOSSurfaceMVK                                             ) vkGetInstanceProcAddr( instance, "vkCreateIOSSurfaceMVK" );
            }

            // VK_MVK_macos_surface : load instance level function definitions
            else static if( __traits( isSame, extension, MVK_macos_surface )) {
                vkCreateMacOSSurfaceMVK                                           = cast( PFN_vkCreateMacOSSurfaceMVK                                           ) vkGetInstanceProcAddr( instance, "vkCreateMacOSSurfaceMVK" );
            }

            // VK_FUCHSIA_imagepipe_surface : load instance level function definitions
            else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
                vkCreateImagePipeSurfaceFUCHSIA                                   = cast( PFN_vkCreateImagePipeSurfaceFUCHSIA                                   ) vkGetInstanceProcAddr( instance, "vkCreateImagePipeSurfaceFUCHSIA" );
            }

            // VK_EXT_metal_surface : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_metal_surface )) {
                vkCreateMetalSurfaceEXT                                           = cast( PFN_vkCreateMetalSurfaceEXT                                           ) vkGetInstanceProcAddr( instance, "vkCreateMetalSurfaceEXT" );
            }

            // VK_EXT_full_screen_exclusive : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                vkGetPhysicalDeviceSurfacePresentModes2EXT                        = cast( PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceSurfacePresentModes2EXT" );
            }

            // VK_EXT_directfb_surface : load instance level function definitions
            else static if( __traits( isSame, extension, EXT_directfb_surface )) {
                vkCreateDirectFBSurfaceEXT                                        = cast( PFN_vkCreateDirectFBSurfaceEXT                                        ) vkGetInstanceProcAddr( instance, "vkCreateDirectFBSurfaceEXT" );
                vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 = cast( PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 ) vkGetInstanceProcAddr( instance, "vkGetPhysicalDeviceDirectFBPresentationSupportEXT" );
            }
        }
    }

    // compose a new loadDeviceLevelFunctions function out of
    // unextended original function and additional function pointers from extensions
    void loadDeviceLevelFunctionsKHR( VkInstance instance ) {

        // first load all non platform related function pointers from implementation
        erupted.functions.loadDeviceLevelFunctions( instance );

        // 3. loop through alias sequence and mixin corresponding
        // instance based device level function pointer definitions
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_external_memory_win32 : load instance based device level function definitions
            static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                vkGetMemoryWin32HandleKHR                         = cast( PFN_vkGetMemoryWin32HandleKHR                         ) vkGetInstanceProcAddr( instance, "vkGetMemoryWin32HandleKHR" );
                vkGetMemoryWin32HandlePropertiesKHR               = cast( PFN_vkGetMemoryWin32HandlePropertiesKHR               ) vkGetInstanceProcAddr( instance, "vkGetMemoryWin32HandlePropertiesKHR" );
            }

            // VK_KHR_external_semaphore_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                vkImportSemaphoreWin32HandleKHR                   = cast( PFN_vkImportSemaphoreWin32HandleKHR                   ) vkGetInstanceProcAddr( instance, "vkImportSemaphoreWin32HandleKHR" );
                vkGetSemaphoreWin32HandleKHR                      = cast( PFN_vkGetSemaphoreWin32HandleKHR                      ) vkGetInstanceProcAddr( instance, "vkGetSemaphoreWin32HandleKHR" );
            }

            // VK_KHR_external_fence_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                vkImportFenceWin32HandleKHR                       = cast( PFN_vkImportFenceWin32HandleKHR                       ) vkGetInstanceProcAddr( instance, "vkImportFenceWin32HandleKHR" );
                vkGetFenceWin32HandleKHR                          = cast( PFN_vkGetFenceWin32HandleKHR                          ) vkGetInstanceProcAddr( instance, "vkGetFenceWin32HandleKHR" );
            }

            // VK_KHR_deferred_host_operations : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_deferred_host_operations )) {
                vkCreateDeferredOperationKHR                      = cast( PFN_vkCreateDeferredOperationKHR                      ) vkGetInstanceProcAddr( instance, "vkCreateDeferredOperationKHR" );
                vkDestroyDeferredOperationKHR                     = cast( PFN_vkDestroyDeferredOperationKHR                     ) vkGetInstanceProcAddr( instance, "vkDestroyDeferredOperationKHR" );
                vkGetDeferredOperationMaxConcurrencyKHR           = cast( PFN_vkGetDeferredOperationMaxConcurrencyKHR           ) vkGetInstanceProcAddr( instance, "vkGetDeferredOperationMaxConcurrencyKHR" );
                vkGetDeferredOperationResultKHR                   = cast( PFN_vkGetDeferredOperationResultKHR                   ) vkGetInstanceProcAddr( instance, "vkGetDeferredOperationResultKHR" );
                vkDeferredOperationJoinKHR                        = cast( PFN_vkDeferredOperationJoinKHR                        ) vkGetInstanceProcAddr( instance, "vkDeferredOperationJoinKHR" );
            }

            // VK_NV_external_memory_win32 : load instance based device level function definitions
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                vkGetMemoryWin32HandleNV                          = cast( PFN_vkGetMemoryWin32HandleNV                          ) vkGetInstanceProcAddr( instance, "vkGetMemoryWin32HandleNV" );
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : load instance based device level function definitions
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                vkGetAndroidHardwareBufferPropertiesANDROID       = cast( PFN_vkGetAndroidHardwareBufferPropertiesANDROID       ) vkGetInstanceProcAddr( instance, "vkGetAndroidHardwareBufferPropertiesANDROID" );
                vkGetMemoryAndroidHardwareBufferANDROID           = cast( PFN_vkGetMemoryAndroidHardwareBufferANDROID           ) vkGetInstanceProcAddr( instance, "vkGetMemoryAndroidHardwareBufferANDROID" );
            }

            // VK_EXT_full_screen_exclusive : load instance based device level function definitions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                vkAcquireFullScreenExclusiveModeEXT               = cast( PFN_vkAcquireFullScreenExclusiveModeEXT               ) vkGetInstanceProcAddr( instance, "vkAcquireFullScreenExclusiveModeEXT" );
                vkReleaseFullScreenExclusiveModeEXT               = cast( PFN_vkReleaseFullScreenExclusiveModeEXT               ) vkGetInstanceProcAddr( instance, "vkReleaseFullScreenExclusiveModeEXT" );
                vkGetDeviceGroupSurfacePresentModes2EXT           = cast( PFN_vkGetDeviceGroupSurfacePresentModes2EXT           ) vkGetInstanceProcAddr( instance, "vkGetDeviceGroupSurfacePresentModes2EXT" );
            }

            // VK_KHR_ray_tracing : load instance based device level function definitions
            else static if( __traits( isSame, extension, KHR_ray_tracing )) {
                vkCreateAccelerationStructureKHR                  = cast( PFN_vkCreateAccelerationStructureKHR                  ) vkGetInstanceProcAddr( instance, "vkCreateAccelerationStructureKHR" );
                vkGetAccelerationStructureMemoryRequirementsKHR   = cast( PFN_vkGetAccelerationStructureMemoryRequirementsKHR   ) vkGetInstanceProcAddr( instance, "vkGetAccelerationStructureMemoryRequirementsKHR" );
                vkCmdBuildAccelerationStructureKHR                = cast( PFN_vkCmdBuildAccelerationStructureKHR                ) vkGetInstanceProcAddr( instance, "vkCmdBuildAccelerationStructureKHR" );
                vkCmdBuildAccelerationStructureIndirectKHR        = cast( PFN_vkCmdBuildAccelerationStructureIndirectKHR        ) vkGetInstanceProcAddr( instance, "vkCmdBuildAccelerationStructureIndirectKHR" );
                vkBuildAccelerationStructureKHR                   = cast( PFN_vkBuildAccelerationStructureKHR                   ) vkGetInstanceProcAddr( instance, "vkBuildAccelerationStructureKHR" );
                vkCopyAccelerationStructureKHR                    = cast( PFN_vkCopyAccelerationStructureKHR                    ) vkGetInstanceProcAddr( instance, "vkCopyAccelerationStructureKHR" );
                vkCopyAccelerationStructureToMemoryKHR            = cast( PFN_vkCopyAccelerationStructureToMemoryKHR            ) vkGetInstanceProcAddr( instance, "vkCopyAccelerationStructureToMemoryKHR" );
                vkCopyMemoryToAccelerationStructureKHR            = cast( PFN_vkCopyMemoryToAccelerationStructureKHR            ) vkGetInstanceProcAddr( instance, "vkCopyMemoryToAccelerationStructureKHR" );
                vkWriteAccelerationStructuresPropertiesKHR        = cast( PFN_vkWriteAccelerationStructuresPropertiesKHR        ) vkGetInstanceProcAddr( instance, "vkWriteAccelerationStructuresPropertiesKHR" );
                vkCmdCopyAccelerationStructureKHR                 = cast( PFN_vkCmdCopyAccelerationStructureKHR                 ) vkGetInstanceProcAddr( instance, "vkCmdCopyAccelerationStructureKHR" );
                vkCmdCopyAccelerationStructureToMemoryKHR         = cast( PFN_vkCmdCopyAccelerationStructureToMemoryKHR         ) vkGetInstanceProcAddr( instance, "vkCmdCopyAccelerationStructureToMemoryKHR" );
                vkCmdCopyMemoryToAccelerationStructureKHR         = cast( PFN_vkCmdCopyMemoryToAccelerationStructureKHR         ) vkGetInstanceProcAddr( instance, "vkCmdCopyMemoryToAccelerationStructureKHR" );
                vkCmdTraceRaysKHR                                 = cast( PFN_vkCmdTraceRaysKHR                                 ) vkGetInstanceProcAddr( instance, "vkCmdTraceRaysKHR" );
                vkCreateRayTracingPipelinesKHR                    = cast( PFN_vkCreateRayTracingPipelinesKHR                    ) vkGetInstanceProcAddr( instance, "vkCreateRayTracingPipelinesKHR" );
                vkGetAccelerationStructureDeviceAddressKHR        = cast( PFN_vkGetAccelerationStructureDeviceAddressKHR        ) vkGetInstanceProcAddr( instance, "vkGetAccelerationStructureDeviceAddressKHR" );
                vkGetRayTracingCaptureReplayShaderGroupHandlesKHR = cast( PFN_vkGetRayTracingCaptureReplayShaderGroupHandlesKHR ) vkGetInstanceProcAddr( instance, "vkGetRayTracingCaptureReplayShaderGroupHandlesKHR" );
                vkCmdTraceRaysIndirectKHR                         = cast( PFN_vkCmdTraceRaysIndirectKHR                         ) vkGetInstanceProcAddr( instance, "vkCmdTraceRaysIndirectKHR" );
                vkGetDeviceAccelerationStructureCompatibilityKHR  = cast( PFN_vkGetDeviceAccelerationStructureCompatibilityKHR  ) vkGetInstanceProcAddr( instance, "vkGetDeviceAccelerationStructureCompatibilityKHR" );
            }
        }
    }

    // compose a new device based loadDeviceLevelFunctions function
    // out of unextended original and additional function pointers from extensions
    void loadDeviceLevelFunctionsKHR( VkDevice device ) {

        // first load all non platform related function pointers from implementation
        erupted.functions.loadDeviceLevelFunctions( device );

        // 4. loop through alias sequence and mixin corresponding
        // device based device level function pointer definitions
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_external_memory_win32 : load device based device level function definitions
            static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                vkGetMemoryWin32HandleKHR                         = cast( PFN_vkGetMemoryWin32HandleKHR                         ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleKHR" );
                vkGetMemoryWin32HandlePropertiesKHR               = cast( PFN_vkGetMemoryWin32HandlePropertiesKHR               ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandlePropertiesKHR" );
            }

            // VK_KHR_external_semaphore_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                vkImportSemaphoreWin32HandleKHR                   = cast( PFN_vkImportSemaphoreWin32HandleKHR                   ) vkGetDeviceProcAddr( device, "vkImportSemaphoreWin32HandleKHR" );
                vkGetSemaphoreWin32HandleKHR                      = cast( PFN_vkGetSemaphoreWin32HandleKHR                      ) vkGetDeviceProcAddr( device, "vkGetSemaphoreWin32HandleKHR" );
            }

            // VK_KHR_external_fence_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                vkImportFenceWin32HandleKHR                       = cast( PFN_vkImportFenceWin32HandleKHR                       ) vkGetDeviceProcAddr( device, "vkImportFenceWin32HandleKHR" );
                vkGetFenceWin32HandleKHR                          = cast( PFN_vkGetFenceWin32HandleKHR                          ) vkGetDeviceProcAddr( device, "vkGetFenceWin32HandleKHR" );
            }

            // VK_KHR_deferred_host_operations : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_deferred_host_operations )) {
                vkCreateDeferredOperationKHR                      = cast( PFN_vkCreateDeferredOperationKHR                      ) vkGetDeviceProcAddr( device, "vkCreateDeferredOperationKHR" );
                vkDestroyDeferredOperationKHR                     = cast( PFN_vkDestroyDeferredOperationKHR                     ) vkGetDeviceProcAddr( device, "vkDestroyDeferredOperationKHR" );
                vkGetDeferredOperationMaxConcurrencyKHR           = cast( PFN_vkGetDeferredOperationMaxConcurrencyKHR           ) vkGetDeviceProcAddr( device, "vkGetDeferredOperationMaxConcurrencyKHR" );
                vkGetDeferredOperationResultKHR                   = cast( PFN_vkGetDeferredOperationResultKHR                   ) vkGetDeviceProcAddr( device, "vkGetDeferredOperationResultKHR" );
                vkDeferredOperationJoinKHR                        = cast( PFN_vkDeferredOperationJoinKHR                        ) vkGetDeviceProcAddr( device, "vkDeferredOperationJoinKHR" );
            }

            // VK_NV_external_memory_win32 : load device based device level function definitions
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                vkGetMemoryWin32HandleNV                          = cast( PFN_vkGetMemoryWin32HandleNV                          ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleNV" );
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : load device based device level function definitions
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                vkGetAndroidHardwareBufferPropertiesANDROID       = cast( PFN_vkGetAndroidHardwareBufferPropertiesANDROID       ) vkGetDeviceProcAddr( device, "vkGetAndroidHardwareBufferPropertiesANDROID" );
                vkGetMemoryAndroidHardwareBufferANDROID           = cast( PFN_vkGetMemoryAndroidHardwareBufferANDROID           ) vkGetDeviceProcAddr( device, "vkGetMemoryAndroidHardwareBufferANDROID" );
            }

            // VK_EXT_full_screen_exclusive : load device based device level function definitions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                vkAcquireFullScreenExclusiveModeEXT               = cast( PFN_vkAcquireFullScreenExclusiveModeEXT               ) vkGetDeviceProcAddr( device, "vkAcquireFullScreenExclusiveModeEXT" );
                vkReleaseFullScreenExclusiveModeEXT               = cast( PFN_vkReleaseFullScreenExclusiveModeEXT               ) vkGetDeviceProcAddr( device, "vkReleaseFullScreenExclusiveModeEXT" );
                vkGetDeviceGroupSurfacePresentModes2EXT           = cast( PFN_vkGetDeviceGroupSurfacePresentModes2EXT           ) vkGetDeviceProcAddr( device, "vkGetDeviceGroupSurfacePresentModes2EXT" );
            }

            // VK_KHR_ray_tracing : load device based device level function definitions
            else static if( __traits( isSame, extension, KHR_ray_tracing )) {
                vkCreateAccelerationStructureKHR                  = cast( PFN_vkCreateAccelerationStructureKHR                  ) vkGetDeviceProcAddr( device, "vkCreateAccelerationStructureKHR" );
                vkGetAccelerationStructureMemoryRequirementsKHR   = cast( PFN_vkGetAccelerationStructureMemoryRequirementsKHR   ) vkGetDeviceProcAddr( device, "vkGetAccelerationStructureMemoryRequirementsKHR" );
                vkCmdBuildAccelerationStructureKHR                = cast( PFN_vkCmdBuildAccelerationStructureKHR                ) vkGetDeviceProcAddr( device, "vkCmdBuildAccelerationStructureKHR" );
                vkCmdBuildAccelerationStructureIndirectKHR        = cast( PFN_vkCmdBuildAccelerationStructureIndirectKHR        ) vkGetDeviceProcAddr( device, "vkCmdBuildAccelerationStructureIndirectKHR" );
                vkBuildAccelerationStructureKHR                   = cast( PFN_vkBuildAccelerationStructureKHR                   ) vkGetDeviceProcAddr( device, "vkBuildAccelerationStructureKHR" );
                vkCopyAccelerationStructureKHR                    = cast( PFN_vkCopyAccelerationStructureKHR                    ) vkGetDeviceProcAddr( device, "vkCopyAccelerationStructureKHR" );
                vkCopyAccelerationStructureToMemoryKHR            = cast( PFN_vkCopyAccelerationStructureToMemoryKHR            ) vkGetDeviceProcAddr( device, "vkCopyAccelerationStructureToMemoryKHR" );
                vkCopyMemoryToAccelerationStructureKHR            = cast( PFN_vkCopyMemoryToAccelerationStructureKHR            ) vkGetDeviceProcAddr( device, "vkCopyMemoryToAccelerationStructureKHR" );
                vkWriteAccelerationStructuresPropertiesKHR        = cast( PFN_vkWriteAccelerationStructuresPropertiesKHR        ) vkGetDeviceProcAddr( device, "vkWriteAccelerationStructuresPropertiesKHR" );
                vkCmdCopyAccelerationStructureKHR                 = cast( PFN_vkCmdCopyAccelerationStructureKHR                 ) vkGetDeviceProcAddr( device, "vkCmdCopyAccelerationStructureKHR" );
                vkCmdCopyAccelerationStructureToMemoryKHR         = cast( PFN_vkCmdCopyAccelerationStructureToMemoryKHR         ) vkGetDeviceProcAddr( device, "vkCmdCopyAccelerationStructureToMemoryKHR" );
                vkCmdCopyMemoryToAccelerationStructureKHR         = cast( PFN_vkCmdCopyMemoryToAccelerationStructureKHR         ) vkGetDeviceProcAddr( device, "vkCmdCopyMemoryToAccelerationStructureKHR" );
                vkCmdTraceRaysKHR                                 = cast( PFN_vkCmdTraceRaysKHR                                 ) vkGetDeviceProcAddr( device, "vkCmdTraceRaysKHR" );
                vkCreateRayTracingPipelinesKHR                    = cast( PFN_vkCreateRayTracingPipelinesKHR                    ) vkGetDeviceProcAddr( device, "vkCreateRayTracingPipelinesKHR" );
                vkGetAccelerationStructureDeviceAddressKHR        = cast( PFN_vkGetAccelerationStructureDeviceAddressKHR        ) vkGetDeviceProcAddr( device, "vkGetAccelerationStructureDeviceAddressKHR" );
                vkGetRayTracingCaptureReplayShaderGroupHandlesKHR = cast( PFN_vkGetRayTracingCaptureReplayShaderGroupHandlesKHR ) vkGetDeviceProcAddr( device, "vkGetRayTracingCaptureReplayShaderGroupHandlesKHR" );
                vkCmdTraceRaysIndirectKHR                         = cast( PFN_vkCmdTraceRaysIndirectKHR                         ) vkGetDeviceProcAddr( device, "vkCmdTraceRaysIndirectKHR" );
                vkGetDeviceAccelerationStructureCompatibilityKHR  = cast( PFN_vkGetDeviceAccelerationStructureCompatibilityKHR  ) vkGetDeviceProcAddr( device, "vkGetDeviceAccelerationStructureCompatibilityKHR" );
            }
        }
    }

    // compose a new dispatch device out of unextended original dispatch device with
    // extended device based loadDeviceLevelFunctions member function,
    // device and command buffer based function pointer decelerations
    struct DispatchDevice {

        // use unextended dispatch device from module erupted.functions as member and alias this
        erupted.dispatch_device.DispatchDevice commonDispatchDevice;
        alias commonDispatchDevice this;

        // Constructor forwards parameter 'device' to 'this.loadDeviceLevelFunctions'
        this( VkDevice device ) {
            this.loadDeviceLevelFunctionsKHR( device );
        }

        // compose a new device based loadDeviceLevelFunctions member function
        // out of unextended original and additional member function pointers from extensions
        void loadDeviceLevelFunctionsKHR( VkDevice device ) {

            // first load all non platform related member function pointers of wrapped commonDispatchDevice
            commonDispatchDevice.loadDeviceLevelFunctions( device );

            // 5. loop through alias sequence and mixin corresponding
            // device level member function pointer definitions of this wrapping DispatchDevice
            static foreach( extension; noDuplicateExtensions ) {

                // VK_KHR_external_memory_win32 : load dispatch device member function definitions
                static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                    vkGetMemoryWin32HandleKHR                         = cast( PFN_vkGetMemoryWin32HandleKHR                         ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleKHR" );
                    vkGetMemoryWin32HandlePropertiesKHR               = cast( PFN_vkGetMemoryWin32HandlePropertiesKHR               ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandlePropertiesKHR" );
                }

                // VK_KHR_external_semaphore_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                    vkImportSemaphoreWin32HandleKHR                   = cast( PFN_vkImportSemaphoreWin32HandleKHR                   ) vkGetDeviceProcAddr( device, "vkImportSemaphoreWin32HandleKHR" );
                    vkGetSemaphoreWin32HandleKHR                      = cast( PFN_vkGetSemaphoreWin32HandleKHR                      ) vkGetDeviceProcAddr( device, "vkGetSemaphoreWin32HandleKHR" );
                }

                // VK_KHR_external_fence_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                    vkImportFenceWin32HandleKHR                       = cast( PFN_vkImportFenceWin32HandleKHR                       ) vkGetDeviceProcAddr( device, "vkImportFenceWin32HandleKHR" );
                    vkGetFenceWin32HandleKHR                          = cast( PFN_vkGetFenceWin32HandleKHR                          ) vkGetDeviceProcAddr( device, "vkGetFenceWin32HandleKHR" );
                }

                // VK_KHR_deferred_host_operations : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_deferred_host_operations )) {
                    vkCreateDeferredOperationKHR                      = cast( PFN_vkCreateDeferredOperationKHR                      ) vkGetDeviceProcAddr( device, "vkCreateDeferredOperationKHR" );
                    vkDestroyDeferredOperationKHR                     = cast( PFN_vkDestroyDeferredOperationKHR                     ) vkGetDeviceProcAddr( device, "vkDestroyDeferredOperationKHR" );
                    vkGetDeferredOperationMaxConcurrencyKHR           = cast( PFN_vkGetDeferredOperationMaxConcurrencyKHR           ) vkGetDeviceProcAddr( device, "vkGetDeferredOperationMaxConcurrencyKHR" );
                    vkGetDeferredOperationResultKHR                   = cast( PFN_vkGetDeferredOperationResultKHR                   ) vkGetDeviceProcAddr( device, "vkGetDeferredOperationResultKHR" );
                    vkDeferredOperationJoinKHR                        = cast( PFN_vkDeferredOperationJoinKHR                        ) vkGetDeviceProcAddr( device, "vkDeferredOperationJoinKHR" );
                }

                // VK_NV_external_memory_win32 : load dispatch device member function definitions
                else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                    vkGetMemoryWin32HandleNV                          = cast( PFN_vkGetMemoryWin32HandleNV                          ) vkGetDeviceProcAddr( device, "vkGetMemoryWin32HandleNV" );
                }

                // VK_ANDROID_external_memory_android_hardware_buffer : load dispatch device member function definitions
                else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                    vkGetAndroidHardwareBufferPropertiesANDROID       = cast( PFN_vkGetAndroidHardwareBufferPropertiesANDROID       ) vkGetDeviceProcAddr( device, "vkGetAndroidHardwareBufferPropertiesANDROID" );
                    vkGetMemoryAndroidHardwareBufferANDROID           = cast( PFN_vkGetMemoryAndroidHardwareBufferANDROID           ) vkGetDeviceProcAddr( device, "vkGetMemoryAndroidHardwareBufferANDROID" );
                }

                // VK_EXT_full_screen_exclusive : load dispatch device member function definitions
                else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                    vkAcquireFullScreenExclusiveModeEXT               = cast( PFN_vkAcquireFullScreenExclusiveModeEXT               ) vkGetDeviceProcAddr( device, "vkAcquireFullScreenExclusiveModeEXT" );
                    vkReleaseFullScreenExclusiveModeEXT               = cast( PFN_vkReleaseFullScreenExclusiveModeEXT               ) vkGetDeviceProcAddr( device, "vkReleaseFullScreenExclusiveModeEXT" );
                    vkGetDeviceGroupSurfacePresentModes2EXT           = cast( PFN_vkGetDeviceGroupSurfacePresentModes2EXT           ) vkGetDeviceProcAddr( device, "vkGetDeviceGroupSurfacePresentModes2EXT" );
                }

                // VK_KHR_ray_tracing : load dispatch device member function definitions
                else static if( __traits( isSame, extension, KHR_ray_tracing )) {
                    vkCreateAccelerationStructureKHR                  = cast( PFN_vkCreateAccelerationStructureKHR                  ) vkGetDeviceProcAddr( device, "vkCreateAccelerationStructureKHR" );
                    vkGetAccelerationStructureMemoryRequirementsKHR   = cast( PFN_vkGetAccelerationStructureMemoryRequirementsKHR   ) vkGetDeviceProcAddr( device, "vkGetAccelerationStructureMemoryRequirementsKHR" );
                    vkCmdBuildAccelerationStructureKHR                = cast( PFN_vkCmdBuildAccelerationStructureKHR                ) vkGetDeviceProcAddr( device, "vkCmdBuildAccelerationStructureKHR" );
                    vkCmdBuildAccelerationStructureIndirectKHR        = cast( PFN_vkCmdBuildAccelerationStructureIndirectKHR        ) vkGetDeviceProcAddr( device, "vkCmdBuildAccelerationStructureIndirectKHR" );
                    vkBuildAccelerationStructureKHR                   = cast( PFN_vkBuildAccelerationStructureKHR                   ) vkGetDeviceProcAddr( device, "vkBuildAccelerationStructureKHR" );
                    vkCopyAccelerationStructureKHR                    = cast( PFN_vkCopyAccelerationStructureKHR                    ) vkGetDeviceProcAddr( device, "vkCopyAccelerationStructureKHR" );
                    vkCopyAccelerationStructureToMemoryKHR            = cast( PFN_vkCopyAccelerationStructureToMemoryKHR            ) vkGetDeviceProcAddr( device, "vkCopyAccelerationStructureToMemoryKHR" );
                    vkCopyMemoryToAccelerationStructureKHR            = cast( PFN_vkCopyMemoryToAccelerationStructureKHR            ) vkGetDeviceProcAddr( device, "vkCopyMemoryToAccelerationStructureKHR" );
                    vkWriteAccelerationStructuresPropertiesKHR        = cast( PFN_vkWriteAccelerationStructuresPropertiesKHR        ) vkGetDeviceProcAddr( device, "vkWriteAccelerationStructuresPropertiesKHR" );
                    vkCmdCopyAccelerationStructureKHR                 = cast( PFN_vkCmdCopyAccelerationStructureKHR                 ) vkGetDeviceProcAddr( device, "vkCmdCopyAccelerationStructureKHR" );
                    vkCmdCopyAccelerationStructureToMemoryKHR         = cast( PFN_vkCmdCopyAccelerationStructureToMemoryKHR         ) vkGetDeviceProcAddr( device, "vkCmdCopyAccelerationStructureToMemoryKHR" );
                    vkCmdCopyMemoryToAccelerationStructureKHR         = cast( PFN_vkCmdCopyMemoryToAccelerationStructureKHR         ) vkGetDeviceProcAddr( device, "vkCmdCopyMemoryToAccelerationStructureKHR" );
                    vkCmdTraceRaysKHR                                 = cast( PFN_vkCmdTraceRaysKHR                                 ) vkGetDeviceProcAddr( device, "vkCmdTraceRaysKHR" );
                    vkCreateRayTracingPipelinesKHR                    = cast( PFN_vkCreateRayTracingPipelinesKHR                    ) vkGetDeviceProcAddr( device, "vkCreateRayTracingPipelinesKHR" );
                    vkGetAccelerationStructureDeviceAddressKHR        = cast( PFN_vkGetAccelerationStructureDeviceAddressKHR        ) vkGetDeviceProcAddr( device, "vkGetAccelerationStructureDeviceAddressKHR" );
                    vkGetRayTracingCaptureReplayShaderGroupHandlesKHR = cast( PFN_vkGetRayTracingCaptureReplayShaderGroupHandlesKHR ) vkGetDeviceProcAddr( device, "vkGetRayTracingCaptureReplayShaderGroupHandlesKHR" );
                    vkCmdTraceRaysIndirectKHR                         = cast( PFN_vkCmdTraceRaysIndirectKHR                         ) vkGetDeviceProcAddr( device, "vkCmdTraceRaysIndirectKHR" );
                    vkGetDeviceAccelerationStructureCompatibilityKHR  = cast( PFN_vkGetDeviceAccelerationStructureCompatibilityKHR  ) vkGetDeviceProcAddr( device, "vkGetDeviceAccelerationStructureCompatibilityKHR" );
                }
            }
        }

        // 6. loop through alias sequence and mixin corresponding convenience member functions
        // omitting device parameter of this wrapping DispatchDevice. Member vkDevice of commonDispatchDevice is used instead
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_external_memory_win32 : dispatch device convenience member functions
            static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                VkResult  GetMemoryWin32HandleKHR( const( VkMemoryGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle ) { return vkGetMemoryWin32HandleKHR( vkDevice, pGetWin32HandleInfo, pHandle ); }
                VkResult  GetMemoryWin32HandlePropertiesKHR( VkExternalMemoryHandleTypeFlagBits handleType, HANDLE handle, VkMemoryWin32HandlePropertiesKHR* pMemoryWin32HandleProperties ) { return vkGetMemoryWin32HandlePropertiesKHR( vkDevice, handleType, handle, pMemoryWin32HandleProperties ); }
            }

            // VK_KHR_external_semaphore_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                VkResult  ImportSemaphoreWin32HandleKHR( const( VkImportSemaphoreWin32HandleInfoKHR )* pImportSemaphoreWin32HandleInfo ) { return vkImportSemaphoreWin32HandleKHR( vkDevice, pImportSemaphoreWin32HandleInfo ); }
                VkResult  GetSemaphoreWin32HandleKHR( const( VkSemaphoreGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle ) { return vkGetSemaphoreWin32HandleKHR( vkDevice, pGetWin32HandleInfo, pHandle ); }
            }

            // VK_KHR_external_fence_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                VkResult  ImportFenceWin32HandleKHR( const( VkImportFenceWin32HandleInfoKHR )* pImportFenceWin32HandleInfo ) { return vkImportFenceWin32HandleKHR( vkDevice, pImportFenceWin32HandleInfo ); }
                VkResult  GetFenceWin32HandleKHR( const( VkFenceGetWin32HandleInfoKHR )* pGetWin32HandleInfo, HANDLE* pHandle ) { return vkGetFenceWin32HandleKHR( vkDevice, pGetWin32HandleInfo, pHandle ); }
            }

            // VK_KHR_deferred_host_operations : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_deferred_host_operations )) {
                VkResult  CreateDeferredOperationKHR( VkDeferredOperationKHR* pDeferredOperation ) { return vkCreateDeferredOperationKHR( vkDevice, pAllocator, pDeferredOperation ); }
                void      DestroyDeferredOperationKHR( VkDeferredOperationKHR operation ) { vkDestroyDeferredOperationKHR( vkDevice, operation, pAllocator ); }
                uint32_t  GetDeferredOperationMaxConcurrencyKHR( VkDeferredOperationKHR operation ) { return vkGetDeferredOperationMaxConcurrencyKHR( vkDevice, operation ); }
                VkResult  GetDeferredOperationResultKHR( VkDeferredOperationKHR operation ) { return vkGetDeferredOperationResultKHR( vkDevice, operation ); }
                VkResult  DeferredOperationJoinKHR( VkDeferredOperationKHR operation ) { return vkDeferredOperationJoinKHR( vkDevice, operation ); }
            }

            // VK_NV_external_memory_win32 : dispatch device convenience member functions
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                VkResult  GetMemoryWin32HandleNV( VkDeviceMemory memory, VkExternalMemoryHandleTypeFlagsNV handleType, HANDLE* pHandle ) { return vkGetMemoryWin32HandleNV( vkDevice, memory, handleType, pHandle ); }
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : dispatch device convenience member functions
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                VkResult  GetAndroidHardwareBufferPropertiesANDROID( const( AHardwareBuffer )* buffer, VkAndroidHardwareBufferPropertiesANDROID* pProperties ) { return vkGetAndroidHardwareBufferPropertiesANDROID( vkDevice, buffer, pProperties ); }
                VkResult  GetMemoryAndroidHardwareBufferANDROID( const( VkMemoryGetAndroidHardwareBufferInfoANDROID )* pInfo, AHardwareBuffer pBuffer ) { return vkGetMemoryAndroidHardwareBufferANDROID( vkDevice, pInfo, pBuffer ); }
            }

            // VK_EXT_full_screen_exclusive : dispatch device convenience member functions
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                VkResult  AcquireFullScreenExclusiveModeEXT( VkSwapchainKHR swapchain ) { return vkAcquireFullScreenExclusiveModeEXT( vkDevice, swapchain ); }
                VkResult  ReleaseFullScreenExclusiveModeEXT( VkSwapchainKHR swapchain ) { return vkReleaseFullScreenExclusiveModeEXT( vkDevice, swapchain ); }
                VkResult  GetDeviceGroupSurfacePresentModes2EXT( const( VkPhysicalDeviceSurfaceInfo2KHR )* pSurfaceInfo, VkDeviceGroupPresentModeFlagsKHR* pModes ) { return vkGetDeviceGroupSurfacePresentModes2EXT( vkDevice, pSurfaceInfo, pModes ); }
            }

            // VK_KHR_ray_tracing : dispatch device convenience member functions
            else static if( __traits( isSame, extension, KHR_ray_tracing )) {
                VkResult  CreateAccelerationStructureKHR( const( VkAccelerationStructureCreateInfoKHR )* pCreateInfo, VkAccelerationStructureKHR* pAccelerationStructure ) { return vkCreateAccelerationStructureKHR( vkDevice, pCreateInfo, pAllocator, pAccelerationStructure ); }
                void      GetAccelerationStructureMemoryRequirementsKHR( const( VkAccelerationStructureMemoryRequirementsInfoKHR )* pInfo, VkMemoryRequirements2* pMemoryRequirements ) { vkGetAccelerationStructureMemoryRequirementsKHR( vkDevice, pInfo, pMemoryRequirements ); }
                void      CmdBuildAccelerationStructureKHR( uint32_t infoCount, const( VkAccelerationStructureBuildGeometryInfoKHR )* pInfos, const( VkAccelerationStructureBuildOffsetInfoKHR* )* ppOffsetInfos ) { vkCmdBuildAccelerationStructureKHR( commandBuffer, infoCount, pInfos, ppOffsetInfos ); }
                void      CmdBuildAccelerationStructureIndirectKHR( const( VkAccelerationStructureBuildGeometryInfoKHR )* pInfo, VkBuffer indirectBuffer, VkDeviceSize indirectOffset, uint32_t indirectStride ) { vkCmdBuildAccelerationStructureIndirectKHR( commandBuffer, pInfo, indirectBuffer, indirectOffset, indirectStride ); }
                VkResult  BuildAccelerationStructureKHR( uint32_t infoCount, const( VkAccelerationStructureBuildGeometryInfoKHR )* pInfos, const( VkAccelerationStructureBuildOffsetInfoKHR* )* ppOffsetInfos ) { return vkBuildAccelerationStructureKHR( vkDevice, infoCount, pInfos, ppOffsetInfos ); }
                VkResult  CopyAccelerationStructureKHR( const( VkCopyAccelerationStructureInfoKHR )* pInfo ) { return vkCopyAccelerationStructureKHR( vkDevice, pInfo ); }
                VkResult  CopyAccelerationStructureToMemoryKHR( const( VkCopyAccelerationStructureToMemoryInfoKHR )* pInfo ) { return vkCopyAccelerationStructureToMemoryKHR( vkDevice, pInfo ); }
                VkResult  CopyMemoryToAccelerationStructureKHR( const( VkCopyMemoryToAccelerationStructureInfoKHR )* pInfo ) { return vkCopyMemoryToAccelerationStructureKHR( vkDevice, pInfo ); }
                VkResult  WriteAccelerationStructuresPropertiesKHR( uint32_t accelerationStructureCount, const( VkAccelerationStructureKHR )* pAccelerationStructures, VkQueryType queryType, size_t dataSize, void* pData, size_t stride ) { return vkWriteAccelerationStructuresPropertiesKHR( vkDevice, accelerationStructureCount, pAccelerationStructures, queryType, dataSize, pData, stride ); }
                void      CmdCopyAccelerationStructureKHR( const( VkCopyAccelerationStructureInfoKHR )* pInfo ) { vkCmdCopyAccelerationStructureKHR( commandBuffer, pInfo ); }
                void      CmdCopyAccelerationStructureToMemoryKHR( const( VkCopyAccelerationStructureToMemoryInfoKHR )* pInfo ) { vkCmdCopyAccelerationStructureToMemoryKHR( commandBuffer, pInfo ); }
                void      CmdCopyMemoryToAccelerationStructureKHR( const( VkCopyMemoryToAccelerationStructureInfoKHR )* pInfo ) { vkCmdCopyMemoryToAccelerationStructureKHR( commandBuffer, pInfo ); }
                void      CmdTraceRaysKHR( const( VkStridedBufferRegionKHR )* pRaygenShaderBindingTable, const( VkStridedBufferRegionKHR )* pMissShaderBindingTable, const( VkStridedBufferRegionKHR )* pHitShaderBindingTable, const( VkStridedBufferRegionKHR )* pCallableShaderBindingTable, uint32_t width, uint32_t height, uint32_t depth ) { vkCmdTraceRaysKHR( commandBuffer, pRaygenShaderBindingTable, pMissShaderBindingTable, pHitShaderBindingTable, pCallableShaderBindingTable, width, height, depth ); }
                VkResult  CreateRayTracingPipelinesKHR( VkPipelineCache pipelineCache, uint32_t createInfoCount, const( VkRayTracingPipelineCreateInfoKHR )* pCreateInfos, VkPipeline* pPipelines ) { return vkCreateRayTracingPipelinesKHR( vkDevice, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines ); }
                VkDeviceAddress  GetAccelerationStructureDeviceAddressKHR( const( VkAccelerationStructureDeviceAddressInfoKHR )* pInfo ) { return vkGetAccelerationStructureDeviceAddressKHR( vkDevice, pInfo ); }
                VkResult  GetRayTracingCaptureReplayShaderGroupHandlesKHR( VkPipeline pipeline, uint32_t firstGroup, uint32_t groupCount, size_t dataSize, void* pData ) { return vkGetRayTracingCaptureReplayShaderGroupHandlesKHR( vkDevice, pipeline, firstGroup, groupCount, dataSize, pData ); }
                void      CmdTraceRaysIndirectKHR( const( VkStridedBufferRegionKHR )* pRaygenShaderBindingTable, const( VkStridedBufferRegionKHR )* pMissShaderBindingTable, const( VkStridedBufferRegionKHR )* pHitShaderBindingTable, const( VkStridedBufferRegionKHR )* pCallableShaderBindingTable, VkBuffer buffer, VkDeviceSize offset ) { vkCmdTraceRaysIndirectKHR( commandBuffer, pRaygenShaderBindingTable, pMissShaderBindingTable, pHitShaderBindingTable, pCallableShaderBindingTable, buffer, offset ); }
                VkResult  GetDeviceAccelerationStructureCompatibilityKHR( const( VkAccelerationStructureVersionKHR )* Version ) { return vkGetDeviceAccelerationStructureCompatibilityKHR( vkDevice, Version ); }
            }
        }

        // 7. loop last time through alias sequence and mixin corresponding function pointer declarations
        static foreach( extension; noDuplicateExtensions ) {

            // VK_KHR_xlib_surface : dispatch device member function pointer decelerations
            static if( __traits( isSame, extension, KHR_xlib_surface )) {
                PFN_vkCreateXlibSurfaceKHR                                            vkCreateXlibSurfaceKHR;
                PFN_vkGetPhysicalDeviceXlibPresentationSupportKHR                     vkGetPhysicalDeviceXlibPresentationSupportKHR;
            }

            // VK_KHR_xcb_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_xcb_surface )) {
                PFN_vkCreateXcbSurfaceKHR                                             vkCreateXcbSurfaceKHR;
                PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR                      vkGetPhysicalDeviceXcbPresentationSupportKHR;
            }

            // VK_KHR_wayland_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_wayland_surface )) {
                PFN_vkCreateWaylandSurfaceKHR                                         vkCreateWaylandSurfaceKHR;
                PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR                  vkGetPhysicalDeviceWaylandPresentationSupportKHR;
            }

            // VK_KHR_android_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_android_surface )) {
                PFN_vkCreateAndroidSurfaceKHR                                         vkCreateAndroidSurfaceKHR;
            }

            // VK_KHR_win32_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_win32_surface )) {
                PFN_vkCreateWin32SurfaceKHR                                           vkCreateWin32SurfaceKHR;
                PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR                    vkGetPhysicalDeviceWin32PresentationSupportKHR;
            }

            // VK_KHR_external_memory_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleKHR                                         vkGetMemoryWin32HandleKHR;
                PFN_vkGetMemoryWin32HandlePropertiesKHR                               vkGetMemoryWin32HandlePropertiesKHR;
            }

            // VK_KHR_external_semaphore_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_semaphore_win32 )) {
                PFN_vkImportSemaphoreWin32HandleKHR                                   vkImportSemaphoreWin32HandleKHR;
                PFN_vkGetSemaphoreWin32HandleKHR                                      vkGetSemaphoreWin32HandleKHR;
            }

            // VK_KHR_external_fence_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_external_fence_win32 )) {
                PFN_vkImportFenceWin32HandleKHR                                       vkImportFenceWin32HandleKHR;
                PFN_vkGetFenceWin32HandleKHR                                          vkGetFenceWin32HandleKHR;
            }

            // VK_KHR_deferred_host_operations : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_deferred_host_operations )) {
                PFN_vkCreateDeferredOperationKHR                                      vkCreateDeferredOperationKHR;
                PFN_vkDestroyDeferredOperationKHR                                     vkDestroyDeferredOperationKHR;
                PFN_vkGetDeferredOperationMaxConcurrencyKHR                           vkGetDeferredOperationMaxConcurrencyKHR;
                PFN_vkGetDeferredOperationResultKHR                                   vkGetDeferredOperationResultKHR;
                PFN_vkDeferredOperationJoinKHR                                        vkDeferredOperationJoinKHR;
            }

            // VK_GGP_stream_descriptor_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, GGP_stream_descriptor_surface )) {
                PFN_vkCreateStreamDescriptorSurfaceGGP                                vkCreateStreamDescriptorSurfaceGGP;
            }

            // VK_NV_external_memory_win32 : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, NV_external_memory_win32 )) {
                PFN_vkGetMemoryWin32HandleNV                                          vkGetMemoryWin32HandleNV;
            }

            // VK_NN_vi_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, NN_vi_surface )) {
                PFN_vkCreateViSurfaceNN                                               vkCreateViSurfaceNN;
            }

            // VK_EXT_acquire_xlib_display : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_acquire_xlib_display )) {
                PFN_vkAcquireXlibDisplayEXT                                           vkAcquireXlibDisplayEXT;
                PFN_vkGetRandROutputDisplayEXT                                        vkGetRandROutputDisplayEXT;
            }

            // VK_MVK_ios_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, MVK_ios_surface )) {
                PFN_vkCreateIOSSurfaceMVK                                             vkCreateIOSSurfaceMVK;
            }

            // VK_MVK_macos_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, MVK_macos_surface )) {
                PFN_vkCreateMacOSSurfaceMVK                                           vkCreateMacOSSurfaceMVK;
            }

            // VK_ANDROID_external_memory_android_hardware_buffer : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, ANDROID_external_memory_android_hardware_buffer )) {
                PFN_vkGetAndroidHardwareBufferPropertiesANDROID                       vkGetAndroidHardwareBufferPropertiesANDROID;
                PFN_vkGetMemoryAndroidHardwareBufferANDROID                           vkGetMemoryAndroidHardwareBufferANDROID;
            }

            // VK_FUCHSIA_imagepipe_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, FUCHSIA_imagepipe_surface )) {
                PFN_vkCreateImagePipeSurfaceFUCHSIA                                   vkCreateImagePipeSurfaceFUCHSIA;
            }

            // VK_EXT_metal_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_metal_surface )) {
                PFN_vkCreateMetalSurfaceEXT                                           vkCreateMetalSurfaceEXT;
            }

            // VK_EXT_full_screen_exclusive : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_full_screen_exclusive )) {
                PFN_vkGetPhysicalDeviceSurfacePresentModes2EXT                        vkGetPhysicalDeviceSurfacePresentModes2EXT;
                PFN_vkAcquireFullScreenExclusiveModeEXT                               vkAcquireFullScreenExclusiveModeEXT;
                PFN_vkReleaseFullScreenExclusiveModeEXT                               vkReleaseFullScreenExclusiveModeEXT;
                PFN_vkGetDeviceGroupSurfacePresentModes2EXT                           vkGetDeviceGroupSurfacePresentModes2EXT;
            }

            // VK_EXT_directfb_surface : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, EXT_directfb_surface )) {
                PFN_vkCreateDirectFBSurfaceEXT                                        vkCreateDirectFBSurfaceEXT;
                PFN_vkGetPhysicalDeviceDirectFBPresentationSupportEXT                 vkGetPhysicalDeviceDirectFBPresentationSupportEXT;
            }

            // VK_KHR_ray_tracing : dispatch device member function pointer decelerations
            else static if( __traits( isSame, extension, KHR_ray_tracing )) {
                PFN_vkCreateAccelerationStructureKHR                                  vkCreateAccelerationStructureKHR;
                PFN_vkGetAccelerationStructureMemoryRequirementsKHR                   vkGetAccelerationStructureMemoryRequirementsKHR;
                PFN_vkCmdBuildAccelerationStructureKHR                                vkCmdBuildAccelerationStructureKHR;
                PFN_vkCmdBuildAccelerationStructureIndirectKHR                        vkCmdBuildAccelerationStructureIndirectKHR;
                PFN_vkBuildAccelerationStructureKHR                                   vkBuildAccelerationStructureKHR;
                PFN_vkCopyAccelerationStructureKHR                                    vkCopyAccelerationStructureKHR;
                PFN_vkCopyAccelerationStructureToMemoryKHR                            vkCopyAccelerationStructureToMemoryKHR;
                PFN_vkCopyMemoryToAccelerationStructureKHR                            vkCopyMemoryToAccelerationStructureKHR;
                PFN_vkWriteAccelerationStructuresPropertiesKHR                        vkWriteAccelerationStructuresPropertiesKHR;
                PFN_vkCmdCopyAccelerationStructureKHR                                 vkCmdCopyAccelerationStructureKHR;
                PFN_vkCmdCopyAccelerationStructureToMemoryKHR                         vkCmdCopyAccelerationStructureToMemoryKHR;
                PFN_vkCmdCopyMemoryToAccelerationStructureKHR                         vkCmdCopyMemoryToAccelerationStructureKHR;
                PFN_vkCmdTraceRaysKHR                                                 vkCmdTraceRaysKHR;
                PFN_vkCreateRayTracingPipelinesKHR                                    vkCreateRayTracingPipelinesKHR;
                PFN_vkGetAccelerationStructureDeviceAddressKHR                        vkGetAccelerationStructureDeviceAddressKHR;
                PFN_vkGetRayTracingCaptureReplayShaderGroupHandlesKHR                 vkGetRayTracingCaptureReplayShaderGroupHandlesKHR;
                PFN_vkCmdTraceRaysIndirectKHR                                         vkCmdTraceRaysIndirectKHR;
                PFN_vkGetDeviceAccelerationStructureCompatibilityKHR                  vkGetDeviceAccelerationStructureCompatibilityKHR;
            }
        }
    }
}
