/*====================================
  �ߡߡ� PART 2. �׸��� & ���� �ߡߡ� 
 =====================================*/
// 2-3. ���ϱ� Ȥ�� ���ϱ�

// ���� �ۼ��� �ڵ�
/*
public class Study003
{
	public static void main(String[] args) 
	{
		// �� �ڸ��� ���ڷθ� �̷���� 9�ڸ� ���ڿ� S.. ���� ���̿� x, +�� �־� ��������� ������� �� �ִ� ���� ū �� ���ϱ�
		// ��� ������ ���ʺ��� ������� �̷����

		// ���ڰ� 0, 1�� �ƴ϶�� x�� �ϴ°� ū ���� ���ϴ� ���...

		String a = "123123123";
		System.out.println(a.substring(1,1));
		int fin;
		
		// str.substring(i,i)
		for (int i=1; i< a.length(); i++)
		{
			
			if ()
			{
			}
			
		}

	}
}
*/

// �Բ� �ۼ��� �ڵ�
import java.util.*;

public class Study003 {

    public static void main(String[] args) 
		{
        Scanner sc = new Scanner(System.in);
		String str = sc.next();

        // ù ��° ���ڸ� ���ڷ� ������ ���� ����
		long result = str.charAt(0) - '0';
		//-- �̺κ� �� ���� ���ðŰ���.. ����ϱ�!
			// �� �� �߿��� �ϳ��� '0' Ȥ�� '1'�� ���, ���ϱ⺸�ٴ� ���ϱ� ����
			for (int i = 1; i < str.length(); i++)
			{
				int num = str.charAt(i) - '0';
				if (num <= 1 || result <= 1) 
				{
					result += num;
				}
				else
				{
					result *= num;
				}
			}
        System.out.println(result);
		}
}