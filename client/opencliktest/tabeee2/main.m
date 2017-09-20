//
//  main.m
//  tabeee2
//
//  Created by MA21AS on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
/*
#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
*/
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <stdio.h>
#import <string.h>

#import <mach/mach_host.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#include <CoreFoundation/CoreFoundation.h>

#include <assert.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>

void printMemoryInfo()
{
    size_t length;
    int mib[6];
    int result;
    
    printf("Memory Info\n");
    printf("-----------\n");
    
    int pagesize;
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    length = sizeof(pagesize);
    if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
    {
        perror("getting page size");
    }
    printf("Page size = %d bytes\n", pagesize);
    printf("\n");
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS)
    {
        printf("Failed to get VM statistics.");
    }

    printf("Free = %u bytes\n", vmstat.free_count * pagesize);

}

void printProcessorInfo()
{
    size_t length;
    int mib[6];
    int result;
    
    printf("Processor Info\n");
    printf("--------------\n");
    
    mib[0] = CTL_HW;
    mib[1] = HW_CPU_FREQ;
    length = sizeof(result);
    if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
    {
        perror("getting cpu frequency");
    }
    printf("CPU Frequency = %d hz\n", result);
    
    mib[0] = CTL_HW;
    mib[1] = HW_BUS_FREQ;
    length = sizeof(result);
    if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
    {
        perror("getting bus frequency");
    }
    printf("Bus Frequency = %d hz\n", result);
    printf("\n");
}

int printBatteryInfo()
{
    
    printf("Battery Info\n");
    printf("------------\n");
    
    
}

int printProcessInfo() {
    int mib[5];
    struct kinfo_proc *procs = NULL, *newprocs;
    int i, st, nprocs;
    size_t miblen, size;
    
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_ALL;
    mib[3] = 0;
    miblen = 4;
    
    
    st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    
    do {
        
        size += size / 10;
        newprocs = realloc(procs, size);
        if (!newprocs) {
            if (procs) {
                free(procs);
            }
            perror("Error: realloc failed.");
            return (0);
        }
        procs = newprocs;
        st = sysctl(mib, miblen, procs, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st != 0) {
        perror("Error: sysctl(KERN_PROC) failed.");
        return (0);
    }
    
    
    assert(size % sizeof(struct kinfo_proc) == 0);
    
    nprocs = size / sizeof(struct kinfo_proc);
    
    if (!nprocs) {
        perror("Error: printProcessInfo.");
        return(0);
    }
    printf(" PID\tName\n");
    printf("-----\t--------------\n");
    for (i = nprocs-1; i >=0; i--) {
        printf("]\t%t",(int)procs[i].kp_proc.p_pid, procs[i].kp_proc.p_comm);
    }
    free(procs);
    return (0);
}
static void  print_free_memory() {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    
    /* Stats in bytes */
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    natural_t mem_inactive = vm_stat.inactive_count * pagesize;
    NSLog(@"pagesize: %u", pagesize);
    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
    NSLog(@"inactive + free: %u ", mem_inactive + mem_free);
    int mem;
    int mib[2];
    mib[0] = CTL_HW;
    mib[1] = HW_PHYSMEM;
    size_t length = sizeof(mem);
    sysctl(mib, 2, &mem, &length, NULL, 0);
    NSLog(@"Physical memory: %.2fMB", mem/1024.0f/1024.0f);
    
    mib[1] = HW_USERMEM;
    length = sizeof(mem);
    sysctl(mib, 2, &mem, &length, NULL, 0);
    NSLog(@"User memory: %.2fMB", mem/1024.0f/1024.0f);
    NSLog(@"User memory: %.2fMB", [NSProcessInfo processInfo].physicalMemory/1024.0f/1024.0f);
    
}
void report_memory(void) {
    static unsigned last_resident_size=0;
    static unsigned greatest = 0;
    static unsigned last_greatest = 0;
    
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        int diff = (int)info.resident_size - (int)last_resident_size;
        unsigned latest = info.resident_size;
        if( latest > greatest   )   greatest = latest;  // track greatest mem usage
        int greatest_diff = greatest - last_greatest;
        int latest_greatest_diff = latest - greatest;
        NSLog(@"Mem: %10u (%10d) : %10d :   greatest: %10u (%d)", info.resident_size, diff,
              latest_greatest_diff,
              greatest, greatest_diff  );
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
    last_resident_size = info.resident_size;
    last_greatest = greatest;
    
}
int main(int argc, char **argv)
{
    report_memory();
    printf("iPhone Hardware Info\n");
    printf("====================\n");
    printf("\n");
    
    vm_statistics_data_t vmStats;
     
     mach_msg_type_number_t infoCount =HOST_VM_INFO_COUNT;
     
     
     kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
     
     
     
     if(kernReturn != KERN_SUCCESS)
     {
     return NSNotFound;
     }
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
     float vm_free =  pagesize * (vmStats.free_count +vmStats.inactive_count)/(1024.f*1024);
    NSLog(@"yuming code free is%.2f",vm_free);
    
    //printMemoryInfo();
    print_free_memory();
    //printProcessorInfo();
    //printBatteryInfo();
    //printProcessInfo();
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    
}
