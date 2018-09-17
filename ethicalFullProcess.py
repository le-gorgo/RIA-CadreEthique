from sys import argv
import os

def readAndWriteAS(outputClingo,newfile):
   print("translating "+outputClingo+" into "+newfile+"\n")
   f=open(outputClingo,"r")
   l=f.readlines()
   facts=l[0].split()
   f.close()
   f=open(newfile,"w")
   for fact in facts:
      f.write(fact+".\n")
   f.close()

def solve(repclingo,theories,output=""):
   cmd=repclingo+" -V0 0 %s" %(" ".join(theories))
   if len(output)>0:
	cmd+=" > %s" %(output)
   print("Executing : "+cmd)
   os.system(cmd)
   print(".... done.\n")

def main(confFile):
   f=open(confFile,"r")
   lines=[l.strip() for l in f.readlines()]
   mode=-1
   modeLab=["[clingo]","[action theory]","[context]","[causal theory]","[ethical spec]","[ethical theories]", "[trace]", "[causal trace]","[results]","[output]"]
   action=[]
   ctx=[]
   causal=[]
   ethSpec=[]
   ethics=[]
   tr=""
   ctr=""
   resPred=[]
   output=""
   for l in lines:      
      if l[0]=='[':
         mode=modeLab.index(l)
      elif mode>=0:
         if mode==modeLab.index("[clingo]"):
            repclingo=l
         elif mode==modeLab.index("[action theory]"):
            action.append(l)
         elif mode==modeLab.index("[context]"):
            ctx.append(l)
         elif mode==modeLab.index("[causal theory]"):
            causal.append(l)
         elif mode==modeLab.index("[ethical spec]"):
            ethSpec.append(l)
         elif mode==modeLab.index("[ethical theories]"):
            ethics.append(l)
         elif mode==modeLab.index("[trace]"):
            tr=l
         elif mode==modeLab.index("[causal trace]"):
            ctr=l
         elif mode==modeLab.index("[results]"):
            resPred.append(l)
         elif mode==modeLab.index("[output]"):
            output=l
   f.close()
   process(repclingo,action,ctx,causal,ethSpec,ethics,tr,ctr,resPred,output)

def process(clingo,action,ctx,causal,ethSpec,ethics,tr,ctr,resPred,output):
   #step 1 : Event trace
   trRoot=tr[0:tr.rfind('.')] if tr!="" else "tmpTrace"
   solve(clingo,action+ctx,trRoot+'.tmp')
   readAndWriteAS(trRoot+'.tmp',tr)
   #step 2 : causal trace
   ctrRoot=ctr[0:ctr.rfind('.')] if ctr!="" else "tmpTrace"
   solve(clingo,[tr]+causal+ctx,ctrRoot+'.tmp')
   readAndWriteAS(ctrRoot+'.tmp',ctr)
   #step 3 : ethical computation (with formatted result)
   tempOutput=output[0:output.rfind('.')]+".tmp" if output!="" else ""
   if resPred!=[]:
      s="".join(["#show "+pred+".\n" for pred in resPred])
      f=open("filter.tmp","w")
      f.write(s)
      f.close()
      solve(clingo,[ctr,"filter.tmp"]+ethics+ctx+ethSpec,tempOutput)
   else:
      solve(clingo,[ctr]+ethics+ctx+ethSpec,tempOutput)
   if output!="":
      readAndWriteAS(tempOutput,output)
   os.system("rm *.tmp")   

if len(argv)<2:
   print("pas de fichier de config")
else :
   main(argv[1])

