/*====================================
  �ߡߡ� PART 2. �׸��� & ���� �ߡߡ� 
 =====================================*/
// 2-2. 1�� �� ������ 

// ���� �ۼ��� �ڵ�
/*
public class Study002
{
	public static void main(String[] args)
	{	
		// N, K......
		int n = 21;
		int k = 2;
		int count=0; // ���� Ƚ��...

		// n���� 1�� ���� / n�� k�� �������� �� 1... 1,2 ������ �����ؾ� �ϴ� �ּ� Ƚ���� ���ϴ� ���α׷� ���ϱ�
		// n���� 1�� ���� �ͺ��� k�� �����°� �ּ� Ƚ���� �������
		
		// n�� k�� ������ ������ ������ ������ ���ٸ� -1�ϱ�...
		while (true)
		{
			if (n%k == 0)
			{
				n/k
			}
		}
	}
}*/

// �Բ� �ۼ��� �ڵ�
import java.util.*;

public class Study002 {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        // N, K�� ������ �������� �����Ͽ� �Է� �ޱ�
        int n = sc.nextInt();
        int k = sc.nextInt();
        int result = 0;

        while (true) {
            // N�� K�� ������ �������� ���� �� �������� 1�� ����
            int target = (n / k) * k;
            result += (n - target);
            n = target;
            // N�� K���� ���� �� (�� �̻� ���� �� ���� ��) �ݺ��� Ż��
            if (n < k) break;
            // K�� ������
            result += 1;
            n /= k;
        }

        // ���������� ���� ���� ���Ͽ� 1�� ����
        result += (n - 1);
        System.out.println(result);
    }

}