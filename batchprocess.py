read = "/data/scratch/bt211065/20220324_Researchproject/ERS561394/ERR925008_1.fastq"
read2 = "/data/scratch/bt211065/20220324_Researchproject/ERS561394/ERR925008_2.fastq"


from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import itertools


# generator function 
def make_batch(seq_object, num_reads):
  record = True
  intobj = iter(seq_object)
  while record: 
    chunks = [] # append item of generator to list 
    while len(chunks) < num_chunks:  # lenghth of chunks less than num of reads  which is batch size 
      try:
        record = next(intobj) # ouput item in each iteration for each loop 
      except StopIteration:
        record = None # stop iteration at end of iterator object
      if record is None:
        break # stop loop
      chunks.append(record) # append record(bacth size)  to chunks
    if chunks: # if chucks is not
      yield chunks # output chuncks 
        

def batchsize(fastq):
  fn= open(fastq, 'r') 
  test = ([str(rec.description), str(rec.seq)] for rec in SeqIO.parse(fn, 'fastq'))
  total = sum(1 for c in test)
  batchsize = total//3 # can be any number
  fn.close()
  return batchsize

def make_files(files):
  seqobj= SeqIO.parse(open(files), 'fastq')
  size_file=batchsize(files)
  for x, chunks in enumerate(make_batch(seqobj, size_file)):
    print(chunks)
    fname = 'Ba%xk'+ str(x)
    with open(fname, 'w') as f:
      SeqIO.write(chunks, f, 'fastq')

# OUTPUT SAME FILE SIZE  1051053353 as intial file 
# all 3 batch files is made up of 1051053353


print(make_files(read2))
  
  
  
  
  
  #intobject = iter(collections)
  
  #for i in range(len(collections)):
    #filename= 'Batch%n' % (n + 1)  
  
    #for i in range(len(collections)//100):
     # with open(filename,'a') as f:
      #  SeqIO.write(next(intobject), filename ,'fastq')
        
    #i+=100
      


#def make_batches(files):
 # sublist = = make_collection(files)
 # itobject = iter(sublist)
 # for i in range 
  

#print(make_collection(read))
  
  
  #print(len(collections))
  
  #collections[n:1000]


#def make_batches()



    
#make_batches(read)
  


#total_record = 0
#rec = 0
#w#ith open(read) as r:
  #for num,seq in enumerate(r.read().splitlines()):
   #   read_file = open('test_1.fastq', 'a')
    #  read_file.write(seq)
     # occur=seq.count('@ERR925008')
      #if occur != 0:
       # num= occur
      #rec+=num
    
  
  #print(rec)
     
     #counter+=1
      #print(counter)
      #if '@ERR925008' in seq and counter == 
       # break 
      
      
    
    
    
    
    #if '@ERR925008' in seq: ### each seq record starts with @ERR925008
     # occur=seq.count('@ERR925008')
      #total_record+=occur
      
  
  #print(total_record)
    
    
      