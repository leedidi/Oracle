class Study016 
{
// ���� ��)
// Source Data : 10 50 20 30 40
// Sorted Data : 10 20 30 40 50
// ����Ϸ��� �ƹ� Ű�� ��������...

	public static void main(String[] args)
	{

		// Source Data
		int[] a = {10, 50, 20, 30, 40};

		System.out.print("Source Data : ");
		for (int n : a)
			System.out.print(n + " ");
		System.out.println();
		

		// Sorted Data
		boolean flag;
		int temp;
		int pass=0;

		do
		{
			flag = false;
			pass++;
			
			for (int i=0; i<a.length-pass; i++)
			{	
				if (a[i]> a[i+1])  
				{
					temp = a[i]; 
					a[i] = a[i+1];
					a[i+1] = temp;

					flag = true;
					// �ڸ��ٲ��� �߻��ϰ� �Ǹ� flag�� true��...
				}
			}
		}
		while (flag); // flag�� true�� ���� �ݺ�!

		System.out.print("Sorted Data : ");
		for (int n : a)
			System.out.print(n + " ");
		System.out.println();
	}
}


