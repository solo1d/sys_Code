

```assembly
pushad  ;该指令压入32位寄存器，入栈顺序位 EAX,ECX,EDX,EBX,ESP,EBP,ESI,EDI 。 其中EAX最先入栈。

popad   ;该指令会和 pushad组合使用，按照反顺序出栈并写入寄存器。
```

